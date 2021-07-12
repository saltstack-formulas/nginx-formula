## this state creates a file that is used to test vhosts dependencies
# (see https://github.com/saltstack-formulas/nginx-formula/pull/278)

created_to_test_dependencies:
  file.managed:
    - name: /tmp/created_to_test_dependencies
