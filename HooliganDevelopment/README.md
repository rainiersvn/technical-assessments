# NodeJS Stream Checker setup documentation

## Table of Contents
- [Introduction](#introduction)
- [NodeJS runtime](#nodejs-runtime)
- [Setting up the API](#setting-up-the-api)
- [AWS Technologies](#aws-technologies)
- [Scaling possibilities](#scaling-possibilities)
- [Monitoring](#monitoring)
- [Logging](#logging)
- [Final Thoughts](#final-thoughts)



<hr>

## Introduction

Welcome to my completed task of the Hooligan `Backend Assessment` challenge. Please note that the `package.json` file has all the commands necessary to init and run this project, more granular instructions will be given.

I hope you like what you see!

Technologies I opted for in this project:

- TypeScript `v4.7`
- NodeJS `v14.16`
- Jest `v28.1`
- Express `v4.28`
- BodyParser `v1.20`
- Docker `latest`

<hr>

## NodeJS runtime

Install and configure NodeJS 14.16

You can do this manually, via `brew` or with `nvm`.

The node engine is locked down to 14.16 in the package file.

<hr>

## Setting up the API

To set up this project, just ran an `npm i`. I have `clean` | `build` scripts that do just that, clean and build the project.

You can run `npm ci && npm run docker-build` to init and prepare the docker image.

You can run `npm run run-docker-image` to start up the image.

You can run either `npm run start|dev` to start the API locally or using `nodemon` dev server.

<hr>

## AWS Technologies

I made use of the following AWS technologies:
- API Gateway
- ECS
- ACM
- Route53

This API is deployed to `ECS` and behind `API Gateway`. You can access it in the following fashion:
API Gateway
- `https://ved4ydlli4.execute-api.us-east-1.amazonaws.com/live/about` a sort of "is alive" method.
- `https://ved4ydlli4.execute-api.us-east-1.amazonaws.com/live/checkUserStreams` the actual stream checker endpoint.

ECS
- `http://35.173.246.62:8080/about`
- `http://35.173.246.62:8080/checkUserStreams`

I also implemented API Gateway with custom domain mappings, this is an `api` subdomain of my own website `korbanministries.co.za` that exposes this challenge API.

API Gateway Custom Domain
- `https://api.korbanministries.co.za/about` a sort of "is alive" method.
- `https://api.korbanministries.co.za/checkUserStreams` the actual stream checker endpoint.

Please note there is an included `HooliganDevelopmentAssessment.postman_collection.json` file that contains these endpoints for testing.

<hr>

## Scaling possibilities

This is a bit tricky, we have a lot to consider. 

I would for starters think about load. I would invest time in making the API as robust to high volumes of load as it can be. Either using `ECS` to provide high container redundancy, maybe backed by low latency `DynamoDB` database for storing of key-value pairs of user's active streams. 

Initially, I wanted to implement `DynamoDB` instead of a key-value-pair in-memory map, but I opted for keeping the API lightweight.

We could also implement a `Lambda` based solution, lambda's can have high concurrency and run in `NodeJS` as opposed to something like `Java`, which has a JVM|JRE that needs to be spun up, and could also provide some level of redundancy, I would front the lambda solution by something that can provide load distribution like `API Gateway`.

We could even turn the existing app into an `SQS` or `FIFO` based queue that has `Lambda` listening to it, this would prevent `Lambda` from being overloaded, but the queue might pile up. We can have `ECS` cluster's pulling from `SQS|FIFO` as well.

I am sure there are hundreds of other options, these are just some spit-balls I am firing off of some of the knowledge I have concerning `AWS Services`.

<hr>

## Monitoring

With regards to monitoring, AWS has you covered. I know there are a few ways to monitor all of the services, but I would opt to investigate which would be the best.

I know `ECS` has built-in monitoring, as most AWS services do, but I heard `AWS Xray` is quite good for mapping out the complete flow of your whole application system. That might be a good start. 

`CloudWatch` has triggers and things we can set up according to pre defined health rules.

<hr>

## Logging

Your `Monitoring` is partly only as good as your logging, `CloudWatch` is what I am used to for all of my logging purposes. I would invest time into application logs, setting up good debug logging frameworks that not just log when things go wrong, but that give you useful logs for when you need to support your faulty systems. You can't support and investigate a faulty system flying in there blind with bad or no logs.

I have seen this in too many instances before, support being a nightmare because logging has been neglected. Debug logs NEED to be embedded in code and suppressed (but easily enabled) in production, or even logged in production but aggregated and separated from the normal `warm|info|error` logs streams into their own debug streams.

<hr>

## Final thoughts

Some final implementations I would have liked to get to was changing the built-in memory map to use `DynamoDB`, unfortunately, I was starting to run into various issues and was out of time and I would rather submit my working masterpiece than something broken.

I enjoyed this challenge so much, that words cannot describe it. This challenge allowed me to do something I love, be a `DevOps Engineer`, writing code, deploying code, and building cloud infrastructure and applications. I do hope that you like what I put together on the AWS side as this is where I focused.

I would be more than happy to showcase the AWS side of my project in the final 90-minute interview.