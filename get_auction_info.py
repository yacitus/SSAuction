#!/usr/bin/env python
"""get_auction_info.py

Post an auction query to the indicated GraphQL API URL

Usage:
  get_auction_info.py AUCTION_ID [--url=URL] [--verbose]

Options:
  AUCTION_ID - the auction ID to look up

  -u <URL>, --url=<URL>   GraphQL API URL to POST to
                          Defaults to http://localhost:4000/api.
  -v, --verbose           Show details of the GraphQL query
  -h, --help              Show this screen
  -V                      Show get_auction_info version
"""

import json
import os
import pprint
import sys

from docopt import docopt
import requests


def get_auction_info(graphql_url, auction_id, verbose):
    query = """query AuctionInfo($id: Int!) {
  auction(id: $id) {
    id
    name
    active
    bidTimeoutSeconds
  }
}
"""
    variables = """{{
    "id": {}
}}
"""

    if verbose:
        print(query)
        print('variables:')
        print(variables.format(auction_id))

    r = requests.post(graphql_url, json={'query': query,
                                         'variables':
                                            variables.format(auction_id)})
    if r.status_code == 200:
        if verbose:
            print('headers:')
            pprint.pprint(dict(r.headers))

        the_json = r.json()

        if 'data' not in the_json or not the_json['data']:
            print(f'ERROR: no data returned for auction_id: "{auction_id}"',
                  file=sys.stderr)
            if verbose:
                print('JSON:')
                print('-----')
                print(the_json)
            sys.exit(1)

        print()
        print('json:')
        return the_json['data']
    else:
        print('Status code: {}'.format(r.status_code), file=sys.stderr)
        print('Text:', file=sys.stderr)
        print(r.text, file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    arguments = docopt(__doc__, version='copy_s3_sets_to_yaml_file 1.0')
    if 'url' in arguments and arguments['url']:
        url = arguments['url']
    else:
        url = 'http://localhost:4000/api'
    info = get_auction_info(url,
                            arguments['AUCTION_ID'],
                            arguments['--verbose'])
    print(info)
