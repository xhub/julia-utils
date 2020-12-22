using Pkg
using Pkg.Artifacts
import Pkg.BinaryPlatforms
using SHA

###########################################################
# Start of config
###########################################################
name = "ReSHOP"
version = "0.1.0"

url = "https://nullptr.fr/julia/"
files = readdir("/tmp/ReSHOP_jll", join=true)
artifact_toml = "/tmp/$(name)_jll-artifact"

prefix = "$name.v$(version)"
postfix = "tar.gz"


###########################################################
# End of config
###########################################################


for f in files
	f_hash = create_artifact() do artifact_path
		run(`tar xvf $(f) -C $(artifact_path)`)
	end

	d_hash = ""
	open(f) do ff
		d_hash = bytes2hex(sha2_256(ff))
	end
	triplet_str = replace(replace(basename(f), "."*postfix => ""), prefix*"." => "")
	plat = Pkg.BinaryPlatforms.platform_key_abi(triplet_str)

	bind_artifact!(artifact_toml, name, f_hash, platform=plat, download_info=[(url*basename(f), d_hash)])
end

