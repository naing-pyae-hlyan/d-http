# d_http

Dynamic http service with two callback optionals.

## Getting Started

var response = await DHttpService.get(tag: 'GET', url: 'http://www.nph.guru/api/uers', headers: null, body: null,);

OR

DHttpService.get(
  tag: 'GET',
  url: 'http://www.nph.guru/api/users',
  headers: null,
  body: null,
  onResponse: (DHttpResponse resp) {},
  onTimeout: () {},
  onConnectionError() {},
  );

Special thanks to -
#### Naing Myo Thaw
