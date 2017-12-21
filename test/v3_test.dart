import 'package:open_api/v3.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  group("Stripe spec", () {
    APIDocument doc;
    Map<String, dynamic> original;

    setUpAll(() {
      // Spec file is too large for pub, and no other way to remove from pub publish
      // than putting in .gitignore. Therefore, this file must be downloaded locally
      // to this path, from this path: https://raw.githubusercontent.com/stripe/openapi/master/openapi/spec3.json
      var file = new File("test/specs/stripe.json");
      var contents = file.readAsStringSync();
      original = JSON.decode(contents);
      doc = new APIDocument.fromJSON(contents);
    });

    test("Emits same document in asMap()", () {
      final m = doc.asMap();
      expect(doc.asMap(), original);
    });

    test("Has openapi version", () {
      expect(doc.version, "3.0.0");
    });

    test("Has info", () {
      expect(doc.info.title, "Stripe API");
      expect(doc.info.version, "2017-08-15");
      expect(doc.info.description, "The Stripe REST API. Please see https://stripe.com/docs/api for more details.");
      expect(doc.info.termsOfServiceURL, "https://stripe.com/us/terms/");
      expect(doc.info.contact.email, "dev-platform@stripe.com");
      expect(doc.info.contact.name, "Stripe Dev Platform Team");
      expect(doc.info.contact.url, "https://stripe.com");
      expect(doc.info.license, isNull);
    });

    test("Has servers", () {
      expect(doc.servers.length, 1);
      expect(doc.servers.first.url, "https://api.stripe.com/");
      expect(doc.servers.first.description, isNull);
      expect(doc.servers.first.variables, isNull);
    });

    test("Tags", () {
      expect(doc.tags, isNull);
    });

    group("Paths", () {
      test("Sample path 1", () {
        final p = doc.paths["/v1/transfers/{transfer}/reversals/{id}"];
        expect(p, isNotNull);
        expect(p.description, isNull);

        expect(p.operations.length, 2);

        final getOp = p.operations["get"];
        final getParams = getOp.parameters;
        final getResponses = getOp.responses;
        expect(getOp.description, contains("10 most recent reversals"));
        expect(getOp.id, "RetrieveTransferReversal");
        expect(getParams.length, 3);
        expect(getParams[0].location, APIParameterLocation.query);
        expect(getParams[0].description, "Specifies which fields in the response should be expanded.");
        expect(getParams[0].name, "expand");
        expect(getParams[0].isRequired, false);
        expect(getParams[0].schema.type, APIType.array);
        expect(getParams[0].schema.items.type, APIType.string);

        expect(getParams[1].location, APIParameterLocation.path);
        expect(getParams[1].name, "id");
        expect(getParams[1].isRequired, true);
        expect(getParams[1].schema.type, APIType.string);

        expect(getParams[2].location, APIParameterLocation.path);
        expect(getParams[2].name, "transfer");
        expect(getParams[2].isRequired, true);
        expect(getParams[2].schema.type, APIType.string);

        expect(getResponses.length, 2);
        expect(getResponses["200"].content.length, 1);
        expect(getResponses["200"].content["application/json"].schema.referenceURI, "#/components/schemas/transfer_reversal");

        final resolvedElement = getResponses["200"].content["application/json"].schema.properties["balance_transaction"].anyOf;
        expect(resolvedElement.last.properties["amount"].type, APIType.integer);


      });
    });

    group("Components", () {

    });

    test("Security requirement", () {
      expect(doc.security, isNull);
    });
  });
}