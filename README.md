This project contains a set of bash scripts that help with setting up a CLI to work with the AWS cloud. The end goal of
this tool is landing in a fully configured bash prompt, where you can execute your common aws-cli/Terraform/Pulumi
tasks. The scripts are meant to be used in an interactive environment and require user input to work properly
(e.g. credentials decryption password is entered in a shell prompt).

Some of the features:
- encryption of AWS access keys on disk
- setting environment variables for working with various tools (e.g. Terraform, boto)
- authentication using MFA (2FA)
- installing and updating [aws-cli](https://aws.amazon.com/cli/)
- installing [AWS CDK](https://aws.amazon.com/cdk/)
- installing [aws-nuke](https://github.com/rebuy-de/aws-nuke)

<aside class="notice">
This is highly opinionated, personal toolkit, so it may not fit your individual use-case. However, you can use it as an
inspiration for setting up your own environment.
</aside>

## Requirements and limitations

These scripts are written for Bash shells only. They require the following commands to be accessible: `curl`, `gpg`,
`unzip`. The AWS CDK install script works on Ubuntu and Arch Linux.

## Setting up

Run the following commands to set up the tool:

```
git clone https://github.com/ninefiveslabs/aws-workplace.git
cd aws-workplace
./init.sh
```

The script will ask you to provide the following information:
```
Enter your AWS_ACCESS_KEY_ID:
Enter your AWS_SECRET_ACCESS_KEY:
Enter your MFA device ARN (see: https://console.aws.amazon.com/iam/home#/security_credentials):
Enter default region [us-east-1]:
Now comes the GPG encryption password prompt:
Enter passphrase:
```

And it will create `credentials.asc` file containing the encrypted keys and a `config.sh` file with the default region
parameter.

## Usage

Source the `env.sh` file into your shell:

```
. env.sh
```

It will ask for the credentials encryption password and for the current MFA token. It will then start a new session and
substitute the original keys with temporary session keys. Now your shell is ready to work with AWS. You can use the
`aws` command or any other tools that use the env variables for authentication to AWS.

## Description of files in the repo

- `env.sh` - source this file to set up AWS authentication environment variables. It will prompt for credentials file
decryption password and your MFA code
- `clear-env.sh` - source this file to remove all AWS-related environment variables from your shell
- `init.sh` - this script interactively sets up credentials file and other configuration. Can be used only once, on
initial setup of the tool
- `setup.sh` - script that installs additional software (like aws-shell or AWS CDK)
- `config.sh.example` - this file contains example non-secret parameters of the tool
- `aws-nuke-config.yaml.example` - example file with aws-nuke configuration

The following posts/articles were an inspiration for creating this tool:
- https://hackernoon.com/aws-credentials-stored-safer-m5673wd3
- https://dev.to/michrodz/use-mfa-on-the-cli-and-execute-awscli-commands-securely-3i8c
- https://security.stackexchange.com/questions/14000/environment-variable-accessibility-in-linux/14009#14009
- https://unix.stackexchange.com/questions/143958/in-bash-read-after-a-pipe-is-not-setting-values/143959#143959
- https://aws.amazon.com/premiumsupport/knowledge-center/authenticate-mfa-cli/
- https://news.ycombinator.com/item?id=13382734
- https://superuser.com/questions/633715/how-do-i-fix-warning-message-was-not-integrity-protected-when-using-gpg-symme
- https://meta.stackexchange.com/questions/45597/how-can-i-link-to-a-specific-answer/305392#305392 ;)