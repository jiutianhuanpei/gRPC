Pod::Spec.new do |s|
  s.name     = "<projectname>"
  s.version  = "0.0.1"
  s.license  = "New BSD"
  s.authors  = { 'gRPC contributors' => 'grpc-io@googlegroups.com' }
  s.homepage = "http://www.grpc.io/"
  s.summary = "AuthTestService example"
  s.source = { :git => 'https://github.com/grpc/grpc.git' }

  s.ios.deployment_target = "7.1"
  s.osx.deployment_target = "10.9"

  # Base directory where the .proto files are.
  src = "Protos"

  # Directory where the generated files will be placed.
  dir = "Pods/" + s.name

  # Run protoc with the Objective-C and gRPC plugins to generate protocol messages and gRPC clients.

 

  s.prepare_command = <<-CMD
    mkdir -p #{dir}

    protoc -I #{src} --objc_out=#{dir} --grpc_out=#{dir} --plugin=protoc-gen-grpc=/usr/local/bin/grpc_objective_c_plugin #{src}/*.proto
  CMD

  s.subspec "Messages" do |ms|
    ms.source_files = "#{dir}/*.pbobjc.{h,m}", "#{dir}/**/*.pbobjc.{h,m}"
    ms.header_mappings_dir = dir
    ms.requires_arc = false
    ms.dependency 'Protobuf', '~> 3.0.0-beta-3.1'

  end

  s.subspec "Services" do |ss|
    ss.source_files = "#{dir}/*.pbrpc.{h,m}", "#{dir}/**/*.pbrpc.{h,m}"
    ss.header_mappings_dir = dir
    ss.requires_arc = true
    ss.dependency "gRPC", "~> 0.12"
    ss.dependency "#{s.name}/Messages"

  end
  s.xcconfig = { 
      "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1' 
    }

end
