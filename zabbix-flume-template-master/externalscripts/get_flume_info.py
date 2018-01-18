#!/usr/bin/python
'''Python module to query the Apache Flume metrics and get
results that can then be used by Zabbix.
https://github.com/diarworld/zabbix-flume-template
'''
import argparse
import requests
import json
import sys
import os
import time
import stat


class ZabbixFlume():
    '''Class for Apache Flume monitoring.'''

    def __init__(self):
        self.address = 'localhost'
        self.ports = [41414]
        self.tmp_cache_dir = '/tmp'
        self.ret_result = []
        self.final_result_dict = {}

    def collect_metrics(self, port):
        '''Call the metrics URL and return results JSON.'''
        self.final_result_dict = {}
        self.api_address = 'http://{0}:{1}/metrics'.format(
            self.address, port)
        self.ret_result = requests.get(url=self.api_address)
        if len(self.ret_result.text) != 0:
            return self.ret_result.text

    def get_cache_each(self):
        d = {}
        for k in self.ports :
            d[str(k)] = self.get_cache(port=k)
        return d

    def get_cache(self, port, ttl=60):
        '''Get and save metrics JSON to temp file, update temp file if it older than 60 seconds (ttl).'''
        cache = '{0}/flume-stats-{2}-{1}.json'.format(
            self.tmp_cache_dir, self.address, port)
        lock = '{0}/flume-stats-{2}-{1}.lock'.format(
            self.tmp_cache_dir, self.address, port)
        jtime = os.path.exists(cache) and os.path.getmtime(cache) or 0
        if time.time() - jtime > ttl and not os.path.exists(lock):
            open(lock, 'a').close()
            try:
                cache_json = self.collect_metrics(port)
            except:
                cache_json = '{"error":"Unable to get metrics"}'
            with open(cache, 'w') as f:
                f.write(cache_json)
            os.remove(lock)
        ltime = os.path.exists(lock) and os.path.getmtime(lock) or None
        if ltime and time.time() - ltime > ttl * 5:
            os.remove(lock)
        if not os.access(cache, os.X_OK):
            os.chmod(cache, stat.S_IRWXU)
        return json.load(open(cache))

    def discovery(self, flows):
        '''Discover all Apache Flume flows (sources, channels and sinks). Returns Zabbix parsable JSON.'''
        d = {'data': []}
        cache_each = self.get_cache_each()
        for p, cache in cache_each.items():
            for k in cache:
                if cache[k]['Type'] == flows.upper():
                    d['data'].append({'{#NAME}': p+'===='+k})
        print json.dumps(d)

    # flow is port-[SINK,CHANEL,SOURCE]
    def check_metrics(self, flow, metric):
        '''Check specified Apache Flume metric. Returns metric value.'''
        cache_each = self.get_cache_each()
        r = 0
        for p, cache in cache_each.items():
            for k in cache:
                if p+'===='+k == flow:
                    if metric in cache[k]:
                        r = cache[k].get(metric)
                elif k == "error":
                    r = -1
        return r

    def diff_metrics(self, flow, metric1, metric2):
        '''Check difference between two specified Apache Flume metrics in the same flow. Returns difference value.'''
        cache_each = self.get_cache_each()
        r = m1 = m2 = 0

        for p, cache in cache_each.items():
            for k in cache:
                if p+'===='+k == flow:
                    if metric1 in cache[k]:
                        m1 = cache[k].get(metric1)
                    if metric2 in cache[k]:
                        m2 = cache[k].get(metric2)
                elif k == "error":
                    r = -1        
 
        if r != -1:
            r = int(m1) - int(m2)
        return r

if __name__ == '__main__':
    '''Command-line parameters and decoding for Zabbix use/consumption.'''
    parser = argparse.ArgumentParser(
        description='Simple python script for checking flume metrcis via http')
    parser.add_argument('--discover', '-d', metavar=('type'),
                        help='Discover all flume flows by type')
    parser.add_argument('--check', '-c', nargs=2,
                        metavar=('FLOW', 'METRIC'), help='Check specified metric')
    parser.add_argument('--diff', '-f', nargs=3,
                        metavar=('FLOW', 'METRIC1', 'METRIC2'), help='Check difference between two specified metrics')
    parser.add_argument('--address', '-a',
                        help='Flume address. Default is: localhost')
    parser.add_argument('--ports', '-p', type=int, nargs='+',
                        help='Flume http port. list')
    args = parser.parse_args()
    zf = ZabbixFlume()
    if args.address is not None:
        zf.address = args.address
    if args.ports is not None:
        zf.ports = args.ports
    if args.discover is not None:
        zf.discovery(args.discover)
    if args.check is not None:
        flow = args.check[0]
        metric = args.check[1]
        print zf.check_metrics(flow, metric)

    if args.diff is not None:
        flow = args.diff[0]
        metric1 = args.diff[1]
        metric2 = args.diff[2]
        print zf.diff_metrics(flow, metric1, metric2)
