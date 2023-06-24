# coding: utf-8

import json
from datetime import datetime

import pytz
import requests
from dateutil.parser import parse


def fetch_is_premium_plan(
        user_id: str,
        platform: str,
) -> bool:
    revenue_cat_api_base_url = 'https://api.revenuecat.com/v1'
    revenue_cat_public_google_api_key = 'goog_XbYcsvBgIsmYtGWqeJIfEUPXrni'
    premium_plan_entitlement_identifier = 'premium'

    url = f'{revenue_cat_api_base_url}/subscribers/{user_id}'
    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {revenue_cat_public_google_api_key}',
        'X-Platform': 'android',
    }

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
