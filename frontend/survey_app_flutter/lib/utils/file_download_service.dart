import 'dart:html' as html;
import 'dart:typed_data';

/// Service for handling file downloads in the web browser.
class FileDownloadService {
  /// Downloads a CSV file with the provided content.
  ///
  /// Parameters:
  ///   - [csvContent]: The CSV content as a string
  ///   - [fileName]: The name of the file to download (default: 'results.csv')
  ///
  /// Throws an exception if the download fails.
  static Future<void> downloadCsv({
    required String csvContent,
    String fileName = 'results.csv',
  }) async {
    try {
      // Convert CSV string to bytes with UTF-8 encoding (important for special characters)
      final bytes = Uint8List.fromList(csvContent.codeUnits);

      // Create a Blob from the bytes
      final blob = html.Blob([bytes], 'text/csv;charset=utf-8');

      // Create an object URL from the blob
      final url = html.Url.createObjectUrl(blob);

      // Create an anchor element to trigger download
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = fileName;

      // Add to DOM, click, and remove
      html.document.body!.append(anchor);
      anchor.click();

      // Clean up the object URL and remove the anchor
      Future.delayed(const Duration(milliseconds: 500), () {
        html.Url.revokeObjectUrl(url);
        anchor.remove();
      });
    } catch (e) {
      throw Exception('Failed to download CSV: $e');
    }
  }
}
