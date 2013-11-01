object installer;
object filesystem;


object moduletool;
string system_module_path;

static void create(object i, object fs)
{
  installer = i;
  filesystem = fs;
}


int run()
{

  moduletool = Tools.Standalone.module();
  moduletool->load_specs(moduletool->include_path+"/specs");

  // we assume the local module install path is $HOME/lib/pike/modules.
  if(!installer->ilocal)
    system_module_path = moduletool["system_module_path"];
  else
  {
    system_module_path = getenv("HOME") + "/lib/pike/modules";
  }

  system_module_path = combine_path(system_module_path, "../../bin");

  if(!file_stat(system_module_path))
  {
    werror("no bin directory (%s), placing DLL in %s, which probably won't work. Be sure to copy the following files to your pike bin directory.\n", system_module_path, combine_path(system_module_path, "../"));
  system_module_path = combine_path(system_module_path, "../");
    return 0;
  }

  install_dlls();
  return 1;
}

void install_dlls()
{
  foreach(filesystem->get_dir();;string p)
  {
    string fn = p[sizeof(dirname(p))+1..];
    if(has_suffix(lower_case(fn), ".dll"))
    {
      write("Writing " + fn + " to " + system_module_path + ".\n");
      filesystem->cd(dirname(p));
      Stdio.write_file(combine_path(system_module_path, fn), filesystem->open(fn, "r")->read());
    }
  }
}
