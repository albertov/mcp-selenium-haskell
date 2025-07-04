# MCP Selenium Server API Documentation

This document provides comprehensive API documentation for all tools available in the MCP Selenium Server. The server provides browser automation capabilities through standardized MCP (Model Context Protocol) tools.

## Server Information

- **Implementation**: mcp-selenium-haskell
- **Version**: 0.2.0
- **Description**: Selenium WebDriver automation server for browser automation tasks
- **Supported Browsers**: Chrome, Firefox
- **Session Model**: Multi-session with UUID-based session management

## Environment Variables

The server can be configured using the following environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `SELENIUM_HOST` | `127.0.0.1` | Hostname or IP address of the Selenium WebDriver server |
| `SELENIUM_PORT` | `4444` | Port number of the Selenium WebDriver server |

**Example Configuration:**
```bash
export SELENIUM_HOST=selenium.example.com
export SELENIUM_PORT=4444
mcp-selenium-hs
```

## Session Management Architecture

This implementation uses a **multi-session architecture** where each browser session is identified by a unique UUID. This allows multiple concurrent browser sessions to be managed independently.

### Session Lifecycle
1. **Start**: Use `start_browser` to create a new session and receive a `session_id`
2. **Use**: All subsequent tools require the `session_id` parameter
3. **Close**: Use `close_browser` to properly clean up the session

### Session Isolation
- Each session maintains its own browser instance
- Sessions are completely isolated from each other
- Session cleanup is automatic when sessions are closed properly

## Tool Categories

The tools are organized into the following categories:

1. [Session Management](#session-management)
2. [Navigation](#navigation)
3. [Element Location](#element-location)
4. [Element Interaction](#element-interaction)
5. [Advanced Actions](#advanced-actions)
6. [File Operations](#file-operations)
7. [Utility Operations](#utility-operations)
8. [JavaScript Execution](#javascript-execution)
9. [Console Logging](#console-logging)

---

## Session Management

### start_browser

Launches a browser session with configurable options and returns a unique session ID.

**Parameters:**
- `browser` (required): Browser type - "chrome" or "firefox"
- `options` (optional): Browser configuration object
  - `headless` (boolean): Run browser in headless mode (default: false)
  - `arguments` (array of strings): Additional browser arguments
- `enableLogging` (optional, boolean): Enable enhanced logging for debugging (default: false)

**Chrome Browser Arguments Examples:**
```json
{
  "browser": "chrome",
  "options": {
    "headless": true,
    "arguments": [
      "--no-sandbox",
      "--disable-dev-shm-usage",
      "--disable-gpu",
      "--window-size=1920,1080",
      "--disable-web-security",
      "--allow-running-insecure-content",
      "--disable-background-timer-throttling",
      "--disable-renderer-backgrounding",
      "--disable-features=VizDisplayCompositor"
    ]
  },
  "enableLogging": true
}
```

**Firefox Browser Arguments Examples:**
```json
{
  "browser": "firefox",
  "options": {
    "headless": true,
    "arguments": [
      "--width=1920",
      "--height=1080",
      "--safe-mode"
    ]
  },
  "enableLogging": false
}
```

**Response:**
- **Success**: `{"sessionId": "550e8400-e29b-41d4-a716-446655440000", "text": "Browser started successfully"}`
- **Error**: See [Error Response Format](#error-response-format)

**Error Codes:**
- `E001`: Failed to start browser - WebDriver connection failed
- `E002`: Invalid browser type specified
- `E003`: Browser startup timeout

---

### close_browser

Closes a specific browser session and cleans up resources.

**Parameters:**
- `session_id` (required): UUID of the session to close

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Response:**
- **Success**: `{"text": "Browser session closed successfully"}`
- **Error**: See [Error Response Format](#error-response-format)

**Error Codes:**
- `E011`: Session not found
- `E012`: Session already closed
- `E013`: Failed to close browser session

---

## Navigation

### navigate

Navigates to a specified URL in the given session.

**Parameters:**
- `session_id` (required): UUID of the browser session
- `url` (required): URL to navigate to

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "url": "https://example.com"
}
```

**Response:**
- **Success**: `{"text": "Navigated to: https://example.com"}`
- **Error**: See [Error Response Format](#error-response-format)

**Error Codes:**
- `E021`: Session not found
- `E022`: Invalid URL format
- `E023`: Navigation timeout
- `E024`: Page load failed

---

## Element Location

### find_element

Locates an element on the page using various strategies.

**Parameters:**
- `session_id` (required): UUID of the browser session
- `by` (optional): Locator strategy - "id", "css", "xpath", "name", "tag", "class" (default: "id")
- `value` (required): Value for the locator strategy
- `timeout` (optional): Maximum wait time in milliseconds (default: 10000)

**Supported Locator Strategies:**
- `id`: Find by element ID attribute
- `css`: Find by CSS selector (most flexible)
- `xpath`: Find by XPath expression (powerful but can be fragile)
- `name`: Find by name attribute
- `tag`: Find by HTML tag name
- `class`: Find by CSS class name

**Examples:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "by": "css",
  "value": "#submit-button",
  "timeout": 5000
}
```

```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "by": "xpath",
  "value": "//button[contains(text(), 'Submit')]",
  "timeout": 3000
}
```

**Response:**
- **Success**: `{"elementId": "element-uuid-here", "found": true, "text": "Element found"}`
- **Error**: See [Error Response Format](#error-response-format)

**Error Codes:**
- `E031`: Session not found
- `E032`: Element not found within timeout
- `E033`: Invalid locator strategy
- `E034`: Malformed selector

---

### find_elements

Locates multiple elements on the page using various strategies.

**Parameters:**
- `session_id` (required): UUID of the browser session
- `by` (optional): Locator strategy - "id", "css", "xpath", "name", "tag", "class" (default: "id")
- `value` (required): Value for the locator strategy
- `timeout` (optional): Maximum wait time in milliseconds (default: 10000)

**Supported Locator Strategies:**
- `id`: Find by element ID attribute
- `css`: Find by CSS selector (most flexible)
- `xpath`: Find by XPath expression (powerful but can be fragile)
- `name`: Find by name attribute
- `tag`: Find by HTML tag name
- `class`: Find by CSS class name

**Examples:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "by": "css",
  "value": ".item",
  "timeout": 5000
}
```

```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "by": "xpath",
  "value": "//div[@class='product']",
  "timeout": 3000
}
```

**Response:**
- **Success**: `{"elementIds": ["element-uuid-1", "element-uuid-2"], "count": 2, "text": "Found 2 elements"}`
- **Error**: See [Error Response Format](#error-response-format)

**Error Codes:**
- `E031`: Session not found
- `E032`: Elements not found within timeout
- `E033`: Invalid locator strategy
- `E034`: Malformed selector

---

## Element Interaction

### click_element

Clicks on a specified element.

**Parameters:**
- `session_id` (required): UUID of the browser session
- `by` (required): Locator strategy
- `value` (required): Value for the locator strategy
- `timeout` (optional): Maximum wait time in milliseconds (default: 10000)

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "by": "id",
  "value": "submit-btn",
  "timeout": 5000
}
```

**Response:**
- **Success**: `{"text": "Clicked element with id: submit-btn"}`
- **Error**: See [Error Response Format](#error-response-format)

**Error Codes:**
- `E041`: Session not found
- `E042`: Element not found
- `E043`: Element not clickable
- `E044`: Click action failed

---

### send_keys

Sends keystrokes to a specified element (typing text).

**Parameters:**
- `session_id` (required): UUID of the browser session
- `by` (required): Locator strategy
- `value` (required): Value for the locator strategy
- `text` (required): Text to type into the element
- `timeout` (optional): Maximum wait time in milliseconds (default: 10000)

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "by": "name",
  "value": "username",
  "text": "john.doe@example.com",
  "timeout": 5000
}
```

**Response:**
- **Success**: `{"text": "Sent keys to element with name: username"}`
- **Error**: See [Error Response Format](#error-response-format)

**Error Codes:**
- `E051`: Session not found
- `E052`: Element not found
- `E053`: Element not editable
- `E054`: Send keys action failed

---

### get_element_text

Retrieves the text content of a specified element.

**Parameters:**
- `session_id` (required): UUID of the browser session
- `by` (required): Locator strategy
- `value` (required): Value for the locator strategy
- `timeout` (optional): Maximum wait time in milliseconds (default: 10000)

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "by": "css",
  "value": ".status-message",
  "timeout": 3000
}
```

**Response:**
- **Success**: `{"text": "The actual text content of the element"}`
- **Error**: See [Error Response Format](#error-response-format)

**Error Codes:**
- `E061`: Session not found
- `E062`: Element not found
- `E063`: Failed to retrieve text

---

### get_elements_text

Retrieves the text content of multiple elements matching the specified locator.

**Parameters:**
- `session_id` (required): UUID of the browser session
- `by` (required): Locator strategy
- `value` (required): Value for the locator strategy
- `timeout` (optional): Maximum wait time in milliseconds (default: 10000)

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "by": "css",
  "value": ".product-title",
  "timeout": 3000
}
```

**Response:**
- **Success**: `{"texts": ["Product A", "Product B", "Product C"], "count": 3}`
- **Error**: See [Error Response Format](#error-response-format)

**Error Codes:**
- `E061`: Session not found
- `E062`: Elements not found
- `E063`: Failed to retrieve text

---

## Advanced Actions

### hover

Moves the mouse to hover over a specified element.

**Parameters:**
- `session_id` (required): UUID of the browser session
- `by` (required): Locator strategy
- `value` (required): Value for the locator strategy
- `timeout` (optional): Maximum wait time in milliseconds (default: 10000)

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "by": "xpath",
  "value": "//button[@class='dropdown-trigger']"
}
```

**Response:**
- **Success**: `{"text": "Hovered over element"}`
- **Error**: See [Error Response Format](#error-response-format)

---

### double_click

Performs a double click on a specified element.

**Parameters:**
- `session_id` (required): UUID of the browser session
- `by` (required): Locator strategy
- `value` (required): Value for the locator strategy
- `timeout` (optional): Maximum wait time in milliseconds (default: 10000)

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "by": "id",
  "value": "editable-field"
}
```

**Response:**
- **Success**: `{"text": "Double clicked element"}`
- **Error**: See [Error Response Format](#error-response-format)

---

### right_click

Performs a right click (context click) on a specified element using JavaScript events.

**Parameters:**
- `session_id` (required): UUID of the browser session
- `by` (required): Locator strategy
- `value` (required): Value for the locator strategy
- `timeout` (optional): Maximum wait time in milliseconds (default: 10000)

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "by": "css",
  "value": ".context-menu-target"
}
```

**Response:**
- **Success**: `{"text": "Right clicked element"}`
- **Error**: See [Error Response Format](#error-response-format)

---

### drag_and_drop

Drags an element and drops it onto another element.

**Parameters:**
- `session_id` (required): UUID of the browser session
- `by` (required): Source element locator strategy
- `value` (required): Source element value
- `targetBy` (required): Target element locator strategy
- `targetValue` (required): Target element value
- `timeout` (optional): Maximum wait time in milliseconds (default: 10000)

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "by": "id",
  "value": "draggable-item",
  "targetBy": "id",
  "targetValue": "drop-zone"
}
```

**Response:**
- **Success**: `{"text": "Dragged element from draggable-item to drop-zone"}`
- **Error**: See [Error Response Format](#error-response-format)

---

### press_key

Simulates pressing a keyboard key using JavaScript events for better compatibility.

**Parameters:**
- `session_id` (required): UUID of the browser session
- `key` (required): Key to press (e.g., "Enter", "Tab", "Escape", "a", "1")

**Common Key Values:**
- **Navigation**: "Enter", "Tab", "Escape", "Backspace", "Delete"
- **Function keys**: "F1", "F2", "F3", ..., "F12"
- **Arrow keys**: "ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"
- **Modifiers**: "Shift", "Control", "Alt", "Meta"
- **Regular characters**: "a", "A", "1", "!", "@", "#", etc.

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "key": "Enter"
}
```

**Response:**
- **Success**: `{"text": "Pressed key: Enter"}`
- **Error**: See [Error Response Format](#error-response-format)

---

## File Operations

### upload_file

Uploads a file using a file input element.

**Parameters:**
- `session_id` (required): UUID of the browser session
- `by` (required): Locator strategy for the file input element
- `value` (required): Value for the locator strategy
- `filePath` (required): Absolute path to the file to upload
- `timeout` (optional): Maximum wait time in milliseconds (default: 10000)

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "by": "name",
  "value": "file-upload",
  "filePath": "/home/user/documents/report.pdf"
}
```

**Response:**
- **Success**: `{"text": "Uploaded file /home/user/documents/report.pdf to element with name: file-upload"}`
- **Error**: See [Error Response Format](#error-response-format)

**Error Codes:**
- `E091`: Session not found
- `E092`: File not found
- `E093`: Element not found
- `E094`: Element is not a file input
- `E095`: File upload failed

---

## Utility Operations

### take_screenshot

Captures a screenshot of the current page.

**Parameters:**
- `session_id` (required): UUID of the browser session

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Response:**
- **Success**: `{"text": "Screenshot captured: data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA..."}`
- **Error**: See [Error Response Format](#error-response-format)

**Error Codes:**
- `E101`: Session not found
- `E102`: Screenshot capture failed

---

### get_source

Gets the current page's HTML source code.

**Parameters:**
- `session_id` (required): UUID of the browser session

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Response:**
- **Success**: `{"text": "<!DOCTYPE html><html><head><title>Page Title</title>..."}`
- **Error**: See [Error Response Format](#error-response-format)

**Error Codes:**
- `E111`: Session not found
- `E112`: Failed to retrieve page source

---

## JavaScript Execution

### execute_js

Executes JavaScript code in the browser and returns the result.

**Parameters:**
- `session_id` (required): UUID of the browser session
- `script` (required): JavaScript code to execute
- `args` (optional): Array of arguments to pass to the script (can be any JSON values: strings, numbers, objects, arrays, booleans, null)
- `timeout` (optional): Script execution timeout in milliseconds (default: 30000)

**JavaScript Execution Context:**
- The script executes in the browser's current page context
- Script has access to the page's DOM and global variables
- Arguments are passed as parameters to the script function
- The script should return a value (primitive, object, or null)
- Objects are automatically JSON-serialized in the response

**Security Considerations:**
- JavaScript execution is unrestricted and runs with full page privileges
- Scripts can modify page content, access cookies, and make network requests
- Use with caution on untrusted pages or when handling sensitive data

**Example - Simple calculation:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "script": "return 2 + 3;"
}
```

**Example - DOM manipulation:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "script": "document.getElementById('myButton').style.backgroundColor = 'red'; return 'Color changed';"
}
```

**Example - Using arguments:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "script": "var name = arguments[0]; var age = arguments[1]; return 'Hello ' + name + ', you are ' + age + ' years old';",
  "args": ["John", "25"],
  "timeout": 10000
}
```

**Example - Using diverse argument types:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "script": "var str = arguments[0]; var num = arguments[1]; var obj = arguments[2]; var arr = arguments[3]; var bool = arguments[4]; return {string: str, number: num, object: obj, array: arr, boolean: bool};",
  "args": ["hello", 42, {"key": "value"}, [1, 2, 3], true]
}
```

**Example - Extracting page data:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "script": "return {title: document.title, url: window.location.href, elementCount: document.querySelectorAll('*').length};"
}
```

**Response:**
- **Success**: `{"text": "The return value of the JavaScript execution (as string)"}`
- **Error**: See [Error Response Format](#error-response-format)

**Error Codes:**
- `E121`: Session not found
- `E122`: JavaScript syntax error
- `E123`: JavaScript runtime error
- `E124`: Script execution timeout
- `E125`: Script execution failed

---

## Console Logging

The server provides comprehensive tools for capturing and analyzing browser console logs.

### get_console_logs

Retrieves JavaScript console logs from the browser.

**Parameters:**
- `session_id` (required): UUID of the browser session
- `logLevel` (optional): Filter logs by level - "ALL", "SEVERE", "WARNING", "INFO", "DEBUG" (default: "ALL")
- `maxEntries` (optional): Maximum number of log entries to return (default: unlimited)

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "logLevel": "SEVERE",
  "maxEntries": 50
}
```

**Response:**
- **Success**:
```json
{
  "logs": [
    {
      "level": "SEVERE",
      "message": "Uncaught TypeError: Cannot read property 'foo' of undefined",
      "timestamp": "2024-01-15T10:30:00Z"
    }
  ]
}
```
- **Error**: See [Error Response Format](#error-response-format)

---

### get_available_log_types

Retrieves the available log types supported by the current browser session.

**Parameters:**
- `session_id` (required): UUID of the browser session

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Response:**
- **Success**: `{"logTypes": ["browser", "driver", "performance"]}`
- **Error**: See [Error Response Format](#error-response-format)

---

### inject_console_logger

Injects a JavaScript script to capture all console messages including console.log, console.warn, console.error, etc.

**Parameters:**
- `session_id` (required): UUID of the browser session
- `timeout` (optional): Script execution timeout in milliseconds (default: 60000)

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "timeout": 30000
}
```

**Response:**
- **Success**: `{"text": "Console logger injected successfully"}`
- **Error**: See [Error Response Format](#error-response-format)

---

### get_injected_console_logs

Retrieves console logs captured by the injected logger script.

**Parameters:**
- `session_id` (required): UUID of the browser session
- `clear` (optional): Clear the captured logs after retrieving them (default: false)

**Example:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "clear": true
}
```

**Response:**
- **Success**: JSON string with captured console logs
- **Error**: See [Error Response Format](#error-response-format)

---

## Error Response Format

All tools return standardized error responses when operations fail:

```json
{
  "isError": true,
  "text": "Human-readable error message",
  "errorCode": "E001",
  "details": {
    "operation": "start_browser",
    "sessionId": "550e8400-e29b-41d4-a716-446655440000",
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

## Common Error Scenarios

### Session Management Errors
- **E011**: Session not found - The specified session_id doesn't exist or has been closed
- **E012**: Session already closed - Attempting to use a previously closed session

### Element Interaction Errors
- **E032**: Element not found - The specified element selector didn't match any elements
- **E043**: Element not clickable - Element is hidden, disabled, or obscured
- **E053**: Element not editable - Attempting to send keys to a non-input element

### Browser Errors
- **E001**: WebDriver connection failed - Cannot connect to Selenium server
- **E023**: Navigation timeout - Page took too long to load

### File Operation Errors
- **E092**: File not found - The specified file path doesn't exist
- **E094**: Not a file input - Attempting to upload to a non-file input element

## Best Practices

### Session Management
1. **Always start a browser session** before using other tools
2. **Store session IDs** returned from start_browser for subsequent operations
3. **Close sessions** when automation tasks are complete to free resources
4. **Handle session errors** gracefully - sessions may timeout or be closed externally

### Element Location
1. **Use stable locators** like ID or data attributes over fragile ones like XPath with positions
2. **Set appropriate timeouts** based on expected page load times
3. **Prefer CSS selectors** over XPath for better performance and readability
4. **Test selectors** in browser DevTools before use

### Error Handling
1. **Check responses** for isError flag before proceeding
2. **Implement retry logic** for transient failures
3. **Log error details** including error codes for debugging
4. **Handle timeouts** appropriately - some operations may take longer than default timeouts

### Performance
1. **Use headless mode** for better performance when visual feedback isn't needed
2. **Batch operations** when possible to reduce network overhead
3. **Set reasonable timeouts** - too short causes false failures, too long wastes time
4. **Close sessions promptly** to free browser resources

### Console Logging
1. **Inject logger early** in page lifecycle for comprehensive monitoring
2. **Clear logs periodically** to prevent memory buildup
3. **Filter log levels** to focus on relevant messages
4. **Use both native and injected** logging for complete coverage

## Multi-Session Workflow Examples

### Sequential Automation
```json
// Session 1: Login workflow
{
  "tool": "start_browser",
  "arguments": {
    "browser": "chrome",
    "options": {"headless": true}
  }
}
// Returns: {"sessionId": "session-1", ...}

{
  "tool": "navigate",
  "arguments": {
    "session_id": "session-1",
    "url": "https://app.example.com/login"
  }
}

// Session 2: Admin workflow (concurrent)
{
  "tool": "start_browser",
  "arguments": {
    "browser": "chrome",
    "options": {"headless": false}
  }
}
// Returns: {"sessionId": "session-2", ...}

{
  "tool": "navigate",
  "arguments": {
    "session_id": "session-2",
    "url": "https://admin.example.com"
  }
}
```

### Testing Multiple Browsers
```json
// Chrome session
{
  "tool": "start_browser",
  "arguments": {
    "browser": "chrome",
    "options": {"headless": true}
  }
}

// Firefox session
{
  "tool": "start_browser",
  "arguments": {
    "browser": "firefox",
    "options": {"headless": true}
  }
}

// Run identical tests on both browsers concurrently
```

### Resource Management
```json
// Start multiple sessions for load testing
// sessions: chrome-1, chrome-2, chrome-3, firefox-1

// Clean up all sessions when done
{
  "tool": "close_browser",
  "arguments": {"session_id": "chrome-1"}
}
{
  "tool": "close_browser",
  "arguments": {"session_id": "chrome-2"}
}
// ... close remaining sessions
```

## Troubleshooting Guide

### Connection Issues

**Problem**: WebDriver connection failed (E001)
**Solutions**:
1. Verify Selenium server is running: `curl http://localhost:4444/status`
2. Check SELENIUM_HOST and SELENIUM_PORT environment variables
3. Ensure network connectivity to Selenium server
4. Verify WebDriver version compatibility

**Problem**: Session creation timeout
**Solutions**:
1. Check if browser binaries are installed (Chrome/Firefox)
2. Verify sufficient system resources (memory, CPU)
3. Try headless mode to reduce resource usage
4. Check for conflicting browser processes

### Element Interaction Issues

**Problem**: Element not found (E032)
**Solutions**:
1. Verify element exists on the page
2. Wait for page to fully load before element operations
3. Use browser DevTools to test selectors
4. Check if element is in iframe or shadow DOM
5. Increase timeout for dynamic content

**Problem**: Element not clickable (E043)
**Solutions**:
1. Ensure element is visible and not covered by other elements
2. Wait for element to become clickable
3. Try scrolling element into view first
4. Check if element is disabled or has click handlers

### Performance Issues

**Problem**: Operations are slow
**Solutions**:
1. Use headless mode for better performance
2. Reduce implicit wait timeouts
3. Optimize selectors (prefer ID > CSS > XPath)
4. Use browser automation best practices

### Console Logging Issues

**Problem**: No console logs captured
**Solutions**:
1. Inject console logger before page navigation
2. Check if logging is enabled in browser session
3. Verify page doesn't override console methods
4. Use multiple log types (native + injected)

### File Upload Issues

**Problem**: File upload fails
**Solutions**:
1. Verify file path is absolute and file exists
2. Ensure element is a file input (`<input type="file">`)
3. Check file permissions and accessibility
4. Wait for file input to be ready before upload

## Advanced Usage Patterns

### Error Recovery
```json
// Retry pattern for transient failures
{
  "tool": "click_element",
  "arguments": {
    "session_id": "session-1",
    "by": "css",
    "value": "#submit-btn",
    "timeout": 5000
  }
}
// If error E043 (not clickable), try scrolling into view first
{
  "tool": "execute_js",
  "arguments": {
    "session_id": "session-1",
    "script": "document.querySelector('#submit-btn').scrollIntoView(); return 'scrolled';"
  }
}
// Then retry click
```

### Dynamic Content Handling
```json
// Wait for dynamic content to load
{
  "tool": "execute_js",
  "arguments": {
    "session_id": "session-1",
    "script": "var checkReady = function() { return document.querySelector('.loading') === null && document.querySelector('.content').children.length > 0; }; var start = Date.now(); while (!checkReady() && (Date.now() - start) < 10000) { /* wait */ } return checkReady();"
  }
}
```

### Batch Data Extraction
```json
// Extract multiple data points in one operation
{
  "tool": "execute_js",
  "arguments": {
    "session_id": "session-1",
    "script": "return { title: document.title, url: window.location.href, links: Array.from(document.querySelectorAll('a')).map(a => a.href), forms: document.forms.length };"
  }
}
```
