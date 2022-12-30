module.exports = {
  apps : [{
    name: 'bluetooth1',
    script: 'bluetooth1.js',
    instances: 1,
    autorestart: true,
    watch: false,
  },
  { name: 'bluetooth2',
    script: 'bluetooth2.js',
    instances: 1,
    autorestart: true,
    watch: false,
  },
  { name: 'bluetooth3',
    script: 'bluetooth3.js',
    instances: 1,
    autorestart: true,
    watch: false,
  },
  { name: 'wifi',
    script: 'wifi.js',
    instances: 1,
    autorestart: true,
    watch: false,
  },
  { name: 'lte',
    script: 'lte.js',
    instances: 1,
    autorestart: true,
    watch: false,
  },
  { name: 'disks',
    script: 'disks.sh',
    instances: 1,
    autorestart: true,
    watch: false,
  },
  { name: 'gstreamer',
    script: 'gstreamer.sh',
    instances: 1,
    autorestart: true,
    watch: false,
  }],
};
