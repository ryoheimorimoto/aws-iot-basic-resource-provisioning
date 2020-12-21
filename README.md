# AWS IoT Core - Basic Resource Provisioning

## About

Provisioning of AWS IoT Resource in AWS Console is NOT so understandable and it is boring work. This script helps you to provision AWS IoT Core Resource easily.

## Usage

- Fix the `policy_template.json` file to appropriate your business application.
- Fix the constants of `AWS_REGION` in `iot-resource-provisioning.sh` for your target AWS region.
- Run command as followings.

```
$ sh iot-resource-provisioning.sh 00001
```

- After executing this command, you can find key-pairs and its client certificate in `00001` directory.
