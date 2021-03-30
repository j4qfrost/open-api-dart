import 'package:open_api/src/object.dart';
import 'package:open_api/src/v3/components.dart';
import 'package:open_api/src/v3/document.dart';
import 'package:open_api/src/v3/operation.dart';
import 'package:open_api/src/v3/parameter.dart';

enum APISecuritySchemeType { apiKey, http, oauth2, openID }

class APISecuritySchemeTypeCodec {
  static APISecuritySchemeType decode(String type) {
    switch (type) {
      case "apiKey":
        return APISecuritySchemeType.apiKey;
      case "http":
        return APISecuritySchemeType.http;
      case "oauth2":
        return APISecuritySchemeType.oauth2;
      case "openID":
        return APISecuritySchemeType.openID;
    }
    return null;
  }

  static String encode(APISecuritySchemeType type) {
    switch (type) {
      case APISecuritySchemeType.apiKey:
        return "apiKey";
      case APISecuritySchemeType.http:
        return "http";
      case APISecuritySchemeType.oauth2:
        return "oauth2";
      case APISecuritySchemeType.openID:
        return "openID";
    }
    return null;
  }
}

/// Defines a security scheme that can be used by the operations.
///
/// Supported schemes are HTTP authentication, an API key (either as a header or as a query parameter), OAuth2's common flows (implicit, password, application and access code) as defined in RFC6749, and OpenID Connect Discovery.
class APISecurityScheme extends APIObject {
  APISecurityScheme();
  APISecurityScheme.empty();

  APISecurityScheme.http(this.scheme) : type = APISecuritySchemeType.http;

  APISecurityScheme.apiKey(this.name, this.location)
      : type = APISecuritySchemeType.apiKey;

  APISecurityScheme.oauth2(this.flows) : type = APISecuritySchemeType.oauth2;

  APISecurityScheme.openID(this.connectURL)
      : type = APISecuritySchemeType.openID;

  /// The type of the security scheme.
  ///
  /// REQUIRED. Valid values are "apiKey", "http", "oauth2", "openIdConnect".
  APISecuritySchemeType type;

  /// A short description for security scheme.
  /// CommonMark syntax MAY be used for rich text representation.
  String description;

  /// The name of the header, query or cookie parameter to be used.
  ///
  /// For apiKey only. REQUIRED if so.
  String name;

  /// The location of the API key.
  ///
  /// Valid values are "query", "header" or "cookie".
  ///
  /// For apiKey only. REQUIRED if so.
  APIParameterLocation location;

  /// The name of the HTTP Authorization scheme to be used in the Authorization header as defined in RFC7235.
  ///
  /// For http only. REQUIRED if so.
  String scheme;

  /// A hint to the client to identify how the bearer token is formatted.
  ///
  /// Bearer tokens are usually generated by an authorization server, so this information is primarily for documentation purposes.
  ///
  /// For http only.
  String format;

  /// An object containing configuration information for the flow types supported.
  ///
  /// Fixed keys are implicit, password, clientCredentials and authorizationCode.
  ///
  /// For oauth2 only. REQUIRED if so.
  Map<String, APISecuritySchemeOAuth2Flow> flows;

  /// OpenId Connect URL to discover OAuth2 configuration values.
  ///
  /// This MUST be in the form of a URL.
  ///
  /// For openID only. REQUIRED if so.
  Uri connectURL;

  void decode(KeyedArchive object) {
    super.decode(object);

    type = APISecuritySchemeTypeCodec.decode(object.decode("type"));
    description = object.decode("description");

    switch (type) {
      case APISecuritySchemeType.apiKey:
        {
          name = object.decode("name");
          location = APIParameterLocationCodec.decode(object.decode("in"));
        }
        break;
      case APISecuritySchemeType.oauth2:
        {
          flows = object.decodeObjectMap(
              "flows", () => APISecuritySchemeOAuth2Flow.empty());
        }
        break;
      case APISecuritySchemeType.http:
        {
          scheme = object.decode("scheme");
          format = object.decode("bearerFormat");
        }
        break;
      case APISecuritySchemeType.openID:
        {
          connectURL = object.decode("openIdConnectUrl");
        }
        break;
    }
  }

  void encode(KeyedArchive object) {
    super.encode(object);

    if (type == null) {
      throw ArgumentError(
          "APISecurityScheme must have non-null values for: 'type'.");
    }

    object.encode("type", APISecuritySchemeTypeCodec.encode(type));
    object.encode("description", description);

    switch (type) {
      case APISecuritySchemeType.apiKey:
        {
          if (name == null || location == null) {
            throw ArgumentError(
                "APISecurityScheme with 'apiKey' type must have non-null values for: 'name', 'location'.");
          }

          object.encode("name", name);
          object.encode("in", APIParameterLocationCodec.encode(location));
        }
        break;
      case APISecuritySchemeType.oauth2:
        {
          if (flows == null) {
            throw ArgumentError(
                "APISecurityScheme with 'oauth2' type must have non-null values for: 'flows'.");
          }

          object.encodeObjectMap("flows", flows);
        }
        break;
      case APISecuritySchemeType.http:
        {
          if (scheme == null) {
            throw ArgumentError(
                "APISecurityScheme with 'http' type must have non-null values for: 'scheme'.");
          }

          object.encode("scheme", scheme);
          object.encode("bearerFormat", format);
        }
        break;
      case APISecuritySchemeType.openID:
        {
          if (connectURL == null) {
            throw ArgumentError(
                "APISecurityScheme with 'openID' type must have non-null values for: 'connectURL'.");
          }
          object.encode("openIdConnectUrl", connectURL);
        }
        break;
    }
  }
}

/// Allows configuration of the supported OAuth Flows.
class APISecuritySchemeOAuth2Flow extends APIObject {
  APISecuritySchemeOAuth2Flow.empty();
  APISecuritySchemeOAuth2Flow.code(
      this.authorizationURL, this.tokenURL, this.refreshURL, this.scopes);
  APISecuritySchemeOAuth2Flow.implicit(
      this.authorizationURL, this.refreshURL, this.scopes);
  APISecuritySchemeOAuth2Flow.password(
      this.tokenURL, this.refreshURL, this.scopes);
  APISecuritySchemeOAuth2Flow.client(
      this.tokenURL, this.refreshURL, this.scopes);

  /// The authorization URL to be used for this flow.
  ///
  /// REQUIRED. This MUST be in the form of a URL.
  Uri authorizationURL;

  /// The token URL to be used for this flow.
  ///
  /// REQUIRED. This MUST be in the form of a URL.
  Uri tokenURL;

  /// The URL to be used for obtaining refresh tokens.
  ///
  /// This MUST be in the form of a URL.
  Uri refreshURL;

  /// The available scopes for the OAuth2 security scheme.
  ///
  /// REQUIRED. A map between the scope name and a short description for it.
  Map<String, String> scopes;

  void encode(KeyedArchive object) {
    super.encode(object);

    object.encode("authorizationUrl", authorizationURL);
    object.encode("tokenUrl", tokenURL);
    object.encode("refreshUrl", refreshURL);
    object.encode("scopes", scopes);
  }

  void decode(KeyedArchive object) {
    super.decode(object);

    authorizationURL = object.decode("authorizationUrl");

    tokenURL = object.decode("tokenUrl");
    refreshURL = object.decode("refreshUrl");

    scopes = Map<String, String>.from(object.decode("scopes"));
  }
}

/// Lists the required security schemes to execute an operation.
///
/// The name used for each property MUST correspond to a security scheme declared in [APIComponents.securitySchemes].

/// [APISecurityRequirement] that contain multiple schemes require that all schemes MUST be satisfied for a request to be authorized. This enables support for scenarios where multiple query parameters or HTTP headers are required to convey security information.

/// When a list of [APISecurityRequirement] is defined on the [APIDocument] or [APIOperation], only one of [APISecurityRequirement] in the list needs to be satisfied to authorize the request.
class APISecurityRequirement extends APIObject {
  APISecurityRequirement.empty();
  APISecurityRequirement(this.requirements);

  /// Each name MUST correspond to a security scheme which is declared in [APIComponents.securitySchemes].
  ///
  /// If the security scheme is of type [APISecuritySchemeType.oauth2] or [APISecuritySchemeType.openID], then the value is a list of scope names required for the execution. For other security scheme types, the array MUST be empty.
  Map<String, List<String>> requirements;

  void encode(KeyedArchive object) {
    super.encode(object);

    requirements.forEach((key, value) {
      object.encode(key, value);
    });
  }

  void decode(KeyedArchive object) {
    super.decode(object);

    object.keys.forEach((key) {
      final req = List<String>.from(object.decode(key));
      requirements[key] = req;
    });
  }
}
