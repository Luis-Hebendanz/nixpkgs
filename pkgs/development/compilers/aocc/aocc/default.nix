{ stdenv,
  fetchurl,
  autoPatchelfHook,
  gcc-unwrapped,
  libxml2,
  tlf,
  zlib,
  libffi,
  elfutils,
  libstdcxx5,
  makeWrapper,
  llvmPackages,
  glibc
}:

stdenv.mkDerivation rec {
    pname = "aocc";
    version = "2.1.0";

    src = fetchurl {
        url = "https://developer.amd.com/aocc-compiler-eula/";
        sha256 = "084xgg6xnrjrzl1iyqyrb51f7x2jnmpzdd39ad81dn10db99b405";
        curlOpts = "--data amd_developer_central_nonce=b9697d2a38&_wp_http_referer=%2Faocc-compiler-eula%2F&f=YW9jYy1jb21waWxlci0yLjEuMC50YXI%3D";
        name = "aocc-compiler.tar";
    };

    sourceRoot = ".";

    nativeBuildInputs = [
       autoPatchelfHook
    ];

    runtimeDependencies = [
        glibc
        gcc-unwrapped
    ];

    LIBRARY_PATH = (stdenv.lib.makeSearchPath "" [
        "${llvmPackages.libcxx}/include/c++/v1"
        "${stdenv.lib.getDev stdenv.cc.libc}/include"
        "${glibc}/lib"
        ]);

    buildInputs = [
        stdenv.cc.bintools
       gcc-unwrapped
       libxml2
       zlib
       tlf
       libffi
       elfutils
       makeWrapper
    ];

    installPhase = ''
        runHook preInstall
    
        mkdir -p $out/bin
        mkdir -p $out/lib
        mkdir -p $out/lib32
        mkdir -p $out/include
        mkdir -p $out/share

        srcRoot="$sourceRoot/aocc-compiler-${version}"
        cp --archive \
            $srcRoot/bin/clang-9 $out/bin
        cp --archive \
            $srcRoot/share/* $out/share 
        cp --archive \
            $srcRoot/include/* $out/include 
        cp --archive \
            $srcRoot/lib/* $out/lib 
            
        #wrapProgram $out/bin/clang-9 --set C_INCLUDE_PATH $LIBRARY_PATH

        runHook postInstall
    '';
}
