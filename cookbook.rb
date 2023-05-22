
# Gets set to appid
node.default['ae_vsts_agent']['deployment_group_name'] = 'rsh'
# Set web below to the tier for your recipe (i.e. web since this is tier_web.rb), environment and take into account color if it is given

if node.chef_environment != '_default' && node.chef_environment != 'local'
  include_recipe 'ae_vsts_agent::default'
end

## skip in kitchen environments (local dev & ADO pipeline) - install only in 'PRD'/'STG'/'DBG'/'UAT'/'QA1'/'DV1'
# Locals for customization
tier = node.policy_name[4, 3]
app_id = node.policy_name[0, 3]
env_id = node.policy_group[0, 3]

# Splunk attributes customization for App
node.default['splunk']['accept_license'] = true
node.default['splunk']['client']['host-name'] = {
  'appid': app_id,
  'environment': env_id,
  'role': tier,
}
node.default['splunk']['app_logs'] = {
  'sourcetype': app_id + '_' + tier + '_logs',
  'index': 'apps_' + app_id + '_logs',
  'disabled': false,
}

node.default['ae_splunk']['inputs']['app_logs'] = {
  'sourcetype' => app_id + '_' + tier + '_logs',
  'index' => 'apps_' + app_id + '_logs',
  'disabled' => false,
}

# Set these in the policyfile for your app
node.default['ae_splunk']['inputs']['agent_hostname'] = {
  'appid' => app_id,
  'environment' => env_id,
  'role' => tier,
}
