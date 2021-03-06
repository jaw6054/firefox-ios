/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import XCTest

class NewTabSettingsTest: BaseTestCase {
    // Smoketest
    func testCheckNewTabSettingsByDefault() {
        navigator.goto(NewTabSettings)
        waitForExistence(app.navigationBars["New Tab"])
        XCTAssertTrue(app.tables.cells["Top Sites"].exists)
        XCTAssertTrue(app.tables.cells["Blank Page"].exists)
        XCTAssertTrue(app.tables.cells["Bookmarks"].exists)
        XCTAssertTrue(app.tables.cells["History"].exists)
        XCTAssertTrue(app.tables.switches["ASPocketStoriesVisible"].isEnabled)
        XCTAssertTrue(app.tables.switches["ASBookmarkHighlightsVisible"].isEnabled)
        XCTAssertTrue(app.tables.switches["ASRecentHighlightsVisible"].isEnabled)
    }

    func testToggleOffOnAdditionalContentBookmarks() {
        // Bookmark one site and check it appears in a new tab
        navigator.performAction(Action.BookmarkThreeDots)
        navigator.performAction(Action.OpenNewTabFromTabTray)
        waitForExistence(app.staticTexts["Highlights"])

        // Disable toggle and check that it does not appear in a new tab
        navigator.goto(NewTabSettings)
        navigator.toggleOff(userState.bookmarksInNewTab, withAction: Action.ToggleBookmarksInNewTab)
        navigator.performAction(Action.OpenNewTabFromTabTray)

        //This appears under top sites
        waitForNoExistence(app.staticTexts["Highlights"])

        // Enable toggle again and check it is shown
        navigator.goto(NewTabSettings)
        navigator.toggleOn(userState.bookmarksInNewTab, withAction: Action.ToggleBookmarksInNewTab)
        navigator.performAction(Action.OpenNewTabFromTabTray)
        waitForExistence(app.staticTexts["Highlights"])
    }

    // Smoketest
    func testChangeNewTabSettingsShowBlankPage() {
        navigator.goto(NewTabSettings)
        waitForExistence(app.navigationBars["New Tab"])

        navigator.performAction(Action.SelectNewTabAsBlankPage)
        navigator.performAction(Action.OpenNewTabFromTabTray)

        waitForNoExistence(app.collectionViews.cells["TopSitesCell"])
        waitForNoExistence(app.collectionViews.cells["TopSitesCell"].collectionViews.cells["youtube"])
        waitForNoExistence(app.staticTexts["Highlights"])
    }

    // Smoketest
    func testChangeNewTabSettingsShowYourBookmarks() {
        navigator.goto(NewTabSettings)
        waitForExistence(app.navigationBars["New Tab"])
        // Show Bookmarks panel without bookmarks
        navigator.performAction(Action.SelectNewTabAsBookmarksPage)
        navigator.performAction(Action.OpenNewTabFromTabTray)
        waitForExistence(app.otherElements.images["emptyBookmarks"])

        // Add one bookmark and check the new tab screen
        navigator.openURL(path(forTestPage: "test-mozilla-book.html"))
        waitUntilPageLoad()
        navigator.performAction(Action.Bookmark)
        navigator.nowAt(BrowserTab)
        navigator.performAction(Action.OpenNewTabFromTabTray)
        waitForExistence(app.tables["Bookmarks List"].cells.staticTexts["The Book of Mozilla"])
        waitForNoExistence(app.staticTexts["Highlights"])
    }

    // Smoketest
    func testChangeNewTabSettingsShowYourHistory() {
        navigator.goto(NewTabSettings)
        waitForExistence(app.navigationBars["New Tab"])
        // Show History Panel without history
        navigator.performAction(Action.SelectNewTabAsHistoryPage)
        navigator.performAction(Action.OpenNewTabFromTabTray)
        waitForNoExistence(app.tables.otherElements.staticTexts["Today"])

        // Add one history item and check the new tab screen
        navigator.openURL("example.com")
        navigator.nowAt(BrowserTab)
        navigator.performAction(Action.OpenNewTabFromTabTray)
        waitForExistence(app.tables["History List"].cells.staticTexts["Example Domain"])
    }
}
