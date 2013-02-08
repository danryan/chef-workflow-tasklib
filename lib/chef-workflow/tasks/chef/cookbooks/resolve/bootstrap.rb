# used by resolver tasklibs to ensure their basic dependencies are met. Not to
# be used directly.
begin
  Rake::Task["chef:cookbooks:resolve"].clear
  Rake::Task["chef:cookbooks:update"].clear
rescue
end
