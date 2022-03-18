/**
 * # Terraform Module template
 *
 *
 * ## Description
 *
 * This module is used to report an exsiting flowlog stream in cloudwatch to a central kinesis stream in another account
 *
 * ## Usage
 *
 * Couple with a report receiver deployed in another account. Will need one of these per vpc and/or cloudwatch log group 
 *
 * Resources:
 *
 * * [Article Example](https://article.example.com)
 *
 * ```hcl
    module "flowlog_stream" {
    source                = "../../modules/kinesiss-stream-config"
    source_account        = data.aws_caller_identity.current.id
    security_group_ids    = [module.elmo.es_ingress_sg]
    subnet_ids            = module.elmo.private_subnet_ids
    opensearch_domain_arn = module.elmo.es_domain
    error_logging_bucket  = module.elmo.logging_bucket
    stream_type           = "flowlog"
    }
    module "vpclogs" {
  source             = "../../modules/vpc-flowlog-subscription"
  role_arn           = module.flowlog_stream.publish_role_arn
  kinesis_stream_arn = module.flowlog_stream.destination_arn
  cloudwatch_name    = module.elmo.vpc_cloudwatch_name

}
 * ```
 *
 * ## Testing
 *
 * Run all terratest tests using the `terratest` script.  If using `aws-vault`, you could use `aws-vault exec $AWS_PROFILE -- terratest`.  The `AWS_DEFAULT_REGION` environment variable is required by the tests.  Use `TT_SKIP_DESTROY=1` to not destroy the infrastructure created during the tests.  Use `TT_VERBOSE=1` to log all tests as they are run.  Use `TT_TIMEOUT` to set the timeout for the tests, with the value being in the Go format, e.g., 15m.  The go test command can be executed directly, too.
 *
 * ## Terraform Version
 *
 * Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.
 *
 * Terraform 0.11 and 0.12 are not supported.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 *
 * ## Developer Setup
 *
 * This template is configured to use aws-vault, direnv, go, pre-commit, terraform-docs, and tfenv.  If using Homebrew on macOS, you can install the dependencies using the following code.
 *
 * ```shell
 * brew install aws-vault direnv go pre-commit terraform-docs tfenv
 * pre-commit install --install-hooks
 * ```
 *
 * If using `direnv`, add a `.envrc.local` that sets the default AWS region, e.g., `export AWS_DEFAULT_REGION=us-west-2`.
 *
 * If using `tfenv`, then add a `.terraform-version` to the project root dir, with the version you would like to use.
 *
 *
 */

resource "aws_cloudwatch_log_subscription_filter" "test_lambdafunction_logfilter" {
  name            = format("%s-vpc-flowlog-subscription", local.name_prefix)
  role_arn        = var.role_arn
  log_group_name  = var.cloudwatch_name
  filter_pattern  = "ACCEPT"
  destination_arn = var.kinesis_stream_arn
  distribution    = "Random"
}
