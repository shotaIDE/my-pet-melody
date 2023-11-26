# coding: utf-8

import json
import os
from datetime import datetime

import pytz
import requests
from dateutil.parser import parse

_REVENUE_CAT_API_BASE_URL = 'https://api.revenuecat.com/v1'


def fetch_is_premium_plan(
        user_id: str,
        platform: str,
) -> bool:
    REVENUE_CAT_PUBLIC_APPLE_API_KEY = \
        os.environ['REVENUE_CAT_PUBLIC_APPLE_API_KEY']
    REVENUE_CAT_PUBLIC_GOOGLE_API_KEY = \
        os.environ['REVENUE_CAT_PUBLIC_GOOGLE_API_KEY']

    premium_plan_entitlement_identifier = 'premium'

    url = f'{_REVENUE_CAT_API_BASE_URL}/subscribers/{user_id}'
    headers = {
        'Content-Type': 'application/json',
    }

    if platform == 'iOS':
        headers['Authorization'] = f'Bearer {REVENUE_CAT_PUBLIC_APPLE_API_KEY}'
        headers['X-Platform'] = 'ios'
    elif platform == 'Android':
        headers['Authorization'] = \
            f'Bearer {REVENUE_CAT_PUBLIC_GOOGLE_API_KEY}'
        headers['X-Platform'] = 'android'

    response = requests.get(
        url=url,
        headers=headers,
    )
    response_json = json.loads(response.text)
    entitlements = response_json['subscriber']['entitlements']
    if premium_plan_entitlement_identifier not in entitlements:
        return False

    entitlement = entitlements[premium_plan_entitlement_identifier]
    expire_in_string = entitlement['expires_date']
    expire_in = parse(expire_in_string)

    current = datetime.now(tz=pytz.utc)

    if current >= expire_in:
        return False

    return True
