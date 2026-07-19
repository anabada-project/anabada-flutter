import 'dart:convert';

import 'package:anabada_app/services/api/api_client.dart';
import 'package:anabada_app/services/api/comment_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late http.Request capturedRequest;
  late CommentApi commentApi;

  setUp(() {
    final MockClient httpClient = MockClient((request) async {
      capturedRequest = request;
      return http.Response(
        jsonEncode({
          'data': {'ok': true},
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    commentApi = CommentApi(
      ApiClient(
        baseUrl: 'https://example.com/',
        httpClient: httpClient,
        tokenProvider: () => 'access-token',
      ),
    );
  });

  test('일반 댓글 등록은 백엔드 명세의 필드명을 사용한다', () async {
    await commentApi.create<Map<String, dynamic>>(
      itemId: '42',
      content: '댓글 내용',
      mapper: (json) => json,
    );

    expect(capturedRequest.method, 'POST');
    expect(capturedRequest.url.path, '/api/comment');
    expect(jsonDecode(capturedRequest.body), {
      'product_id': 42,
      'comment_content': '댓글 내용',
    });
  });

  test('대댓글 등록은 content 필드를 유지한다', () async {
    await commentApi.createReply<Map<String, dynamic>>(
      parentCommentId: '7',
      content: '대댓글 내용',
      mapper: (json) => json,
    );

    expect(capturedRequest.method, 'POST');
    expect(capturedRequest.url.path, '/api/comment/7');
    expect(jsonDecode(capturedRequest.body), {'content': '대댓글 내용'});
  });

  test('댓글 수정은 상품 ID와 댓글 내용을 함께 전송한다', () async {
    await commentApi.update<Map<String, dynamic>>(
      commentId: '7',
      itemId: '42',
      content: '수정한 댓글',
      mapper: (json) => json,
    );

    expect(capturedRequest.method, 'PATCH');
    expect(capturedRequest.url.path, '/api/comment/7');
    expect(jsonDecode(capturedRequest.body), {
      'product_id': 42,
      'comment_content': '수정한 댓글',
    });
  });
}
