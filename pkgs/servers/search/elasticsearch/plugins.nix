{ lib, stdenv, fetchurl, unzip, elasticsearch }:

let
  esVersion = elasticsearch.version;

  esPlugin = a@{
    pluginName,
    installPhase ? ''
      mkdir -p $out/config
      mkdir -p $out/plugins
      ln -s ${elasticsearch}/lib $out/lib
      ES_HOME=$out ${elasticsearch}/bin/elasticsearch-plugin install --batch -v file://$src
      rm $out/lib
    '',
    ...
  }:
    stdenv.mkDerivation (a // {
      inherit installPhase;
      pname = "elasticsearch-${pluginName}";
      dontUnpack = true;
      buildInputs = [ unzip ];
      meta = a.meta // {
        platforms = elasticsearch.meta.platforms;
        maintainers = (a.meta.maintainers or []) ++ (with lib.maintainers; [ offline ]);
      };
    });
in {

  analysis-lemmagen = esPlugin rec {
    pluginName = "analysis-lemmagen";
    version = esVersion;
    src = fetchurl {
      url = "https://github.com/vhyza/${pluginName}/releases/download/v${version}/${pluginName}-${version}-plugin.zip";
      sha256 =
        if version == "7.3.1" then "1nb82z6s94mzdx1srb1pwj7cpzs8w74njap0xiqn7sg5ylk6adm8"
        else if version == "6.8.3" then "12bshvp01pp2lgwd0cn9l58axg8gdimsh4g9wfllxi1bdpv4cy53"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = https://github.com/vhyza/elasticsearch-analysis-lemmagen;
      description = "LemmaGen Analysis plugin provides jLemmaGen lemmatizer as Elasticsearch token filter";
      license = licenses.asl20;
    };
  };

  discovery-ec2 = esPlugin rec {
    pluginName = "discovery-ec2";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
      sha256 =
        if version == "7.3.1" then "1p30by7pqnvj8dcwws51kh9s962c42qwqq07gmj4jl83zxcl8kyl"
        else if version == "6.8.3" then "0pmffz761dqjpvmkl7i7xsyw1iyyspqpddxp89rjsznfc9pak5im"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = https://github.com/elastic/elasticsearch/tree/master/plugins/discovery-ec2;
      description = "The EC2 discovery plugin uses the AWS API for unicast discovery.";
      license = licenses.asl20;
    };
  };

  ingest-attachment = esPlugin rec {
    pluginName = "ingest-attachment";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
      sha256 =
        if version == "7.3.1" then "1b9l17zv6582sdcdiabwd293xx5ckc2d3h6smiv6znk5f4dxj7km"
        else if version == "6.8.3" then "0kfr4i2rcwinjn31xrc2piicasjanaqcgnbif9xc7lnak2nnzmll"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = https://github.com/elastic/elasticsearch/tree/master/plugins/ingest-attachment;
      description = "Ingest processor that uses Apache Tika to extract contents";
      license = licenses.asl20;
    };
  };

  repository-s3 = esPlugin rec {
    pluginName = "repository-s3";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${esVersion}.zip";
      sha256 =
        if version == "7.3.1" then "1dqd3hd8qa1bsvd1p42k5zcrdmb66d2yspfc7g8nsz89w6b1invg"
        else if version == "6.8.3" then "1mm6hj2m1db68n81rzsvlw6nisflr5ikzk5zv9nmk0z641n5vh1x"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = https://github.com/elastic/elasticsearch/tree/master/plugins/repository-s3;
      description = "The S3 repository plugin adds support for using AWS S3 as a repository for Snapshot/Restore.";
      license = licenses.asl20;
    };
  };

  repository-gcs = esPlugin rec {
    pluginName = "repository-gcs";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${esVersion}.zip";
      sha256 =
        if version == "7.3.1" then "0kpb1hn2fb4lh6kn96vi7265ign9lwcd0zfc19l4n6fpp8js5lfh"
        else if version == "6.8.3" then "1s2klpvnhpkrk53p64zbga3b66czi7h1a13f58kfn2cn0zfavnbk"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = https://github.com/elastic/elasticsearch/tree/master/plugins/repository-gcs;
      description = "The GCS repository plugin adds support for using Google Cloud Storage as a repository for Snapshot/Restore.";
      license = licenses.asl20;
    };
  };

  search-guard = let
    majorVersion = lib.head (builtins.splitVersion esVersion);
  in esPlugin rec {
    pluginName = "search-guard";
    version =
      # https://docs.search-guard.com/latest/search-guard-versions
      if esVersion == "7.3.1" then "${esVersion}-37.0.0"
      else if esVersion == "6.8.3" then "${esVersion}-25.5"
      else throw "unsupported version ${esVersion} for plugin ${pluginName}";
    src = fetchurl {
      url = "mirror://maven/com/floragunn/${pluginName}-${majorVersion}/${version}/${pluginName}-${majorVersion}-${version}.zip";
      sha256 =
        if version == "7.3.1-37.0.0" then "0rb631npr6vykrhln3x6q75xwb0wndvrspwnak0rld5d7pqn1r04"
        else if version == "6.8.3-25.5" then "0a7ys9qinc0fjyka03cx9rv0pm7wnvslk234zv5vrphkrj52s1cb"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = https://search-guard.com;
      description = "Elasticsearch plugin that offers encryption, authentication, and authorisation. ";
      license = licenses.asl20;
    };
  };
}
