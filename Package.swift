// swift-tools-version:5.0
//
//  Package.swift
//
//

import PackageDescription

let package = Package(name: "SmartPush",
                      platforms: [.macOS(.v10_10),
                                  .iOS(.v9)],
                      products: [.library(name: "SmartPush",
                                          targets: ["SmartPush"])],
                      targets: [.target(name: "SmartPush",
                                        path: "SmartPush",
                                        publicHeadersPath: "")])
