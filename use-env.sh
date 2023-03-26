#!/bin/bash

export $(grep -v ^# .env | xargs); flutter pub run environment_config:generate
