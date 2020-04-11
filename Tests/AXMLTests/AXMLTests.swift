import XCTest
@testable import AXML

final class AXMLtoXMLTests: XCTestCase {
    func testAXMLConversion() throws {
        // Given
        let axml = try Data(contentsOf: input)

        // When
        let xml = try axmlToXml(axml)

        // Then
        XCTAssertEqual(String(decoding: xml, as: UTF8.self), expected)
    }
}

private let input = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .appendingPathComponent("AndroidManifest.xml")

// swiftlint:disable line_length
private let expected = """
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android" android:versionCode="18" android:versionName="2.8.0" android:installLocation="0" android:compileSdkVersion="28" android:compileSdkVersionCodename="9" package="de.cineaste.android" platformBuildVersionCode="28" platformBuildVersionName="9">
    <uses-sdk android:minSdkVersion="19" android:targetSdkVersion="28">
    </uses-sdk>
    <supports-screens android:largeScreens="true" android:xlargeScreens="true">
    </supports-screens>
    <uses-permission android:name="android.permission.INTERNET">
    </uses-permission>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE">
    </uses-permission>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE">
    </uses-permission>
    <application android:theme="@7F110006" android:label="@7F100029" android:icon="@7F0D0000" android:allowBackup="true" android:supportsRtl="true" android:fullBackupContent="true" android:appComponentFactory="androidx.core.app.CoreComponentFactory">
        <activity android:name="de.cineaste.android.MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN">
                </action>
                <category android:name="android.intent.category.LAUNCHER">
                </category>
            </intent-filter>
            <intent-filter>
                <action android:name="android.intent.action.VIEW">
                </action>
                <category android:name="android.intent.category.DEFAULT">
                </category>
                <category android:name="android.intent.category.BROWSABLE">
                </category>
                <data android:scheme="http" android:host="www.cineaste.de">
                </data>
            </intent-filter>
        </activity>
        <activity android:theme="@7F1100CA" android:name="de.cineaste.android.activity.MovieDetailActivity">
        </activity>
        <activity android:name="de.cineaste.android.activity.MovieSearchActivity">
        </activity>
        <activity android:name="de.cineaste.android.activity.AboutActivity">
        </activity>
        <activity android:name="de.cineaste.android.activity.PosterActivity">
        </activity>
        <activity android:name="de.cineaste.android.activity.SeriesSearchActivity">
        </activity>
        <activity android:theme="@7F1100CA" android:name="de.cineaste.android.activity.SeriesDetailActivity">
        </activity>
        <activity android:theme="@7F1100CA" android:name="de.cineaste.android.activity.SeasonDetailActivity">
        </activity>
        <provider android:name="com.squareup.picasso.PicassoProvider" android:exported="false" android:authorities="de.cineaste.android.com.squareup.picasso">
        </provider>
    </application>
</manifest>
"""
