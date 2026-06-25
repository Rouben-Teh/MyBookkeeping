# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## 2026-03-04

### Added

- transaction table
- add
- delete
- list (get all transaction)

## 2026-03-11

### Added

- account table
- authentication
- register
- login
- logout
- month-list

### Changed

- list, add, delete add authentication process
- add (categroy column added)
- transaction table datetime column changed to timestamp

## 2026-03-19

### Added

- sync

### Changed

- timestamp type changed to integer from text
- transaction table added synced column

## 2026-04-08

### Added

- token table added
- soft-delete
- chat
- call llm function

### Changed

- token record change place to token table from account table
- auth return whole auth data instead of only user_id

## 2026-04-30

### Added

- get-chat-history

### Changed

- api key save in server instead of front end provide

### Fixed

- chat timeout set to 300s (LLM will take longer time to response sometimes)

### Removed

- db separated from api.php
- callLLM separate from api.php

## 2026-5-26

### Added

- streak
- count
- statistic

### Changed

- add, sync added type column for income feature
- chat added model_type column for user choose LLM model

### Fixed

- soft-delete bug fixed

## 2026-06-11

### Added

- plan table
- contact table
- settings table
- list-plan
- sync-plan
- contact

### Changed

- login token added device_type column
- transaction table added deleted column
- sync changed to sync-transaction

## 2026-06-24

### Added

- validation
- get-unsync-transactions
- list-settings
- faq

### Changed

- token is_revoked, expired detect enabled
- deviceType changed to device_type in login
- allow 3 web & 3 mobile login in same time
- validation provide new token if old token expired

### Fixed

- list, add, soft-delete, sync-transaction's synced, deleted data insert null bug fixed
- chat return null if LLM server offline bug fixed

---

### Added

### Changed

### Removed

### Fixed
