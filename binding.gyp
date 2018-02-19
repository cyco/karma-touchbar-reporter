{
    "targets": [
        {
            "target_name": "karma-touchbar-reporter",
            "type": "executable",
            "sources": [
                "helper/main.m",
                "helper/RunTracker.m",
                "helper/RepoterDetailsController.m",
                "helper/MessageReader.m",
                "helper/AppDelegate.m",

                "helper/CustomTouchBarItems/ReporterTrayItem.m",
                "helper/CustomTouchBarItems/ResultsTouchBarItem.m",
                "helper/NSImage+Tint.m"
            ],
            "conditions": [
                ['OS=="mac"', {
                    'cflags': ['-fobjc-arc'],
                    'defines': [
                        '__MACOSX_CORE__'
                    ],
                    'link_settings': {
                        'libraries': [
                            '-framework Cocoa',
                            '-framework DFRFoundation',
                            '-framework QuartzCore'
                        ],
                        'include_dirs': [
                            './helper/',
                            './helper/CustomTouchBarItems/',
                            './helper/PrivateInterfaces/',
                        ],
                    },
                    'xcode_settings': {
                        'OTHER_LDFLAGS': [
                            '-F /System/Library/PrivateFrameworks/'
                        ],
                        'OTHER_CFLAGS': [
                            '-fobjc-arc'
                        ],
                    },
                }
                ]]
        }
    ]
}
