class ApiRequest {
  const ApiRequest({
    required this.method,
    required this.path,
    this.body,
    this.queryParameters = const {},
    this.authenticated = true,
  });

  const ApiRequest.get(
    String path, {
    Map<String, String?> queryParameters = const {},
    bool authenticated = true,
  }) : this(
         method: 'GET',
         path: path,
         queryParameters: queryParameters,
         authenticated: authenticated,
       );

  const ApiRequest.post(
    String path, {
    Object? body,
    bool authenticated = true,
  }) : this(
         method: 'POST',
         path: path,
         body: body,
         authenticated: authenticated,
       );

  const ApiRequest.put(
    String path, {
    Object? body,
    bool authenticated = true,
  }) : this(
         method: 'PUT',
         path: path,
         body: body,
         authenticated: authenticated,
       );

  const ApiRequest.patch(
    String path, {
    Object? body,
    bool authenticated = true,
  }) : this(
         method: 'PATCH',
         path: path,
         body: body,
         authenticated: authenticated,
       );

  const ApiRequest.delete(String path, {bool authenticated = true})
    : this(method: 'DELETE', path: path, authenticated: authenticated);

  final String method;
  final String path;
  final Object? body;
  final Map<String, String?> queryParameters;
  final bool authenticated;
}
