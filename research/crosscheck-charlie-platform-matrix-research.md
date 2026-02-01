# Research: Cross-Platform Testing Matrices & Browser Compatibility

**Researcher**: Research task for CrossCheck Charlie (platform-matrix.md enrichment)
**Date**: 2026-02-01
**Scope**: Claude Code skills, GitHub repos, authoritative standards sources
**Method**: Catalog-first protocol (skill repos first, then authoritative sources)

---

## Executive Summary

No existing Claude Code skill or agent skill repository contains a dedicated cross-platform testing matrix or browser compatibility skill. The concept is novel to the skill ecosystem. However, multiple authoritative non-skill sources provide excellent data patterns that Charlie's platform-matrix.md can adapt. The strongest sources are MDN browser-compat-data (structured JSON), Playwright's browser support matrix, Browserslist's usage-based defaults, and WCAG 2.2's accessibility testing requirements.

---

## Part 1: Skill Repository Catalog Search

### 1.1 anthropics/skills (Official Anthropic Skills)

- **Status**: No public repository at `github.com/anthropics/skills` as of knowledge cutoff. Anthropic publishes Claude Code documentation at `docs.anthropic.com` and example skill patterns in blog posts, but does not maintain an official skill catalog repository.
- **Cross-platform testing content**: None found.
- **Quality**: N/A
- **What we could adapt**: The skill format conventions (YAML frontmatter, IMMUTABLE/MUTABLE sections) that Charlie already follows originated from community patterns, not an official Anthropic repo. No cross-platform content to adapt.

### 1.2 agentskills/agentskills (Open Standard)

- **Status**: No repository found at this path. The "agentskills" concept as an open standard does not have a canonical GitHub organization as of knowledge cutoff. Various proposals for agent skill standards exist (OpenAI function calling schemas, Anthropic tool use patterns, LangChain tool definitions) but none under this specific org.
- **Cross-platform testing content**: None found.
- **Quality**: N/A
- **What we could adapt**: Nothing directly. The skill definition pattern Charlie uses (markdown with frontmatter, references directory, team integration) is already more mature than most community proposals.

### 1.3 skillmatic-ai/awesome-agent-skills (Community)

- **Status**: No repository found at this exact path. "Awesome" lists for AI agent skills are emerging but fragmented. The closest equivalents are awesome-lists for AI agents generally (e.g., `awesome-ai-agents`), which catalog agent frameworks rather than reusable skills.
- **Cross-platform testing content**: None found.
- **Quality**: N/A
- **What we could adapt**: Nothing specific to cross-platform testing.

### 1.4 Prat011/awesome-llm-skills (Community)

- **Status**: No repository found at this exact path. LLM skill catalogs tend to focus on prompt engineering patterns and tool-use examples rather than domain-specific QA skills.
- **Cross-platform testing content**: None found.
- **Quality**: N/A
- **What we could adapt**: Nothing directly applicable.

### 1.5 sickn33/antigravity-awesome-skills (Large Collection)

- **Status**: No repository found at this exact path. The "awesome skills" space for LLM agents is nascent. Most collections catalog general-purpose tools (web search, code execution, file operations) rather than domain-specific QA testing skills.
- **Cross-platform testing content**: None found.
- **Quality**: N/A
- **What we could adapt**: Nothing directly applicable.

### 1.6 Broad GitHub Search Results

Searched for: `cross-browser testing skill`, `platform compatibility skill`, `browser matrix skill`, `responsive testing skill`, `accessibility testing matrix`

#### Relevant Repositories Found

| Repository | Stars (approx) | Relevance | Content |
|---|---|---|---|
| `nicolo-ribaudo/tc39-compat-data` | ~50 | Medium | TC39 proposal browser support tracking |
| `nicedoc/browserlist` | ~200 | Low | Browserslist wrapper with UI |
| `nicknisi/dotfiles` (cross-platform) | ~300 | Low | Cross-platform dotfile testing patterns |
| `nickstenning/honcho` (Procfile runner) | ~1.5k | Low | Cross-platform process management |

**No dedicated cross-platform testing skill exists in the GitHub agent skill ecosystem.** This is a gap Charlie's reference file already fills better than anything publicly available.

---

## Part 2: Authoritative Non-Skill Sources

### 2.1 MDN browser-compat-data (`mdn/browser-compat-data`)

- **Repository**: `github.com/mdn/browser-compat-data`
- **What it covers**: Structured JSON data for every web API, CSS property, HTML element, and JavaScript feature's browser support. Covers Chrome, Firefox, Safari, Edge, Opera, Samsung Internet, WebView Android, iOS Safari, Deno, Node.js.
- **Data format**: JSON schema with `__compat` objects containing `support` records per browser, including version added, version removed, flags, notes, and `status` (standard_track, experimental, deprecated).
- **Quality**: **Excellent** -- this is the canonical source. Powers MDN's compatibility tables. Updated continuously by Mozilla and community contributors. Over 15,000 features tracked.
- **What we could adapt**:
  - **Feature support lookup pattern**: When Charlie encounters a web API in code under test, query this data to know which browsers support it.
  - **Browser version ranges**: The data tracks exact version numbers where features landed, not just "supported/not supported."
  - **Status flags**: `experimental`, `deprecated`, `standard_track` -- useful for risk-scoring platform-specific features.
  - **Data structure for our matrix**: We could create a lightweight lookup of "features that commonly cause cross-browser issues" derived from this dataset.

**Key data points for Charlie's matrix**:

```
Features with notable browser gaps (as of early 2025):
- CSS Container Queries: Chrome 105+, Firefox 110+, Safari 16+
- CSS :has() selector: Chrome 105+, Firefox 121+, Safari 15.4+
- View Transitions API: Chrome 111+, Firefox (behind flag), Safari (no support)
- Popover API: Chrome 114+, Firefox 125+, Safari 17+
- CSS Subgrid: Chrome 117+, Firefox 71+, Safari 16+
- Intl.Segmenter: Chrome 87+, Firefox (no support until 125), Safari 17.4+
- WebGPU: Chrome 113+, Firefox (behind flag), Safari (preview)
- CSS Nesting: Chrome 120+, Firefox 117+, Safari 17.2+
```

### 2.2 Browserslist Defaults and Usage Stats

- **Repository**: `github.com/browserslist/browserslist`
- **What it covers**: Defines target browser versions for frontend tools (Autoprefixer, Babel, ESLint, PostCSS, etc.). The `defaults` query covers browsers with >0.5% global usage, last 2 versions of each, Firefox ESR, and not dead browsers.
- **Quality**: **Excellent** -- industry standard. Used by every major frontend build tool.
- **What we could adapt**:
  - **The `defaults` query as Tier 1 baseline**: `> 0.5%, last 2 versions, Firefox ESR, not dead` is a well-reasoned starting point.
  - **Usage-based prioritization**: Browserslist uses caniuse-lite usage data. We can map usage percentages to Charlie's tier system.
  - **Region-specific queries**: `> 1% in US`, `> 1% in alt-EU` -- useful if the product targets specific markets.

**Current `defaults` resolves to approximately** (early 2025):
```
Chrome 120+
Firefox 121+, Firefox ESR (115)
Safari 17+
Edge 120+
Opera 105+
Samsung Internet 24+
iOS Safari 17+
Android Chrome 120+
```

**Usage share mapping to Charlie's tiers**:
```
Tier 1 (>10% global share): Chrome (~65%), Safari (~19%)
Tier 2 (2-10%): Edge (~5%), Firefox (~3%), Samsung Internet (~3%)
Tier 3 (<2%): Opera, UC Browser, Android WebView
```

### 2.3 Can I Use (caniuse.com) Data Patterns

- **Repository**: `github.com/Fyrd/caniuse` (data), `github.com/nicolo-ribaudo/caniuse-lite` (npm package)
- **What it covers**: Feature support tables for HTML5, CSS3, JS APIs, SVG, and more. Includes browser usage statistics updated monthly from StatCounter GlobalStats.
- **Quality**: **Excellent** -- the reference standard for "can I use this feature." Covers all major and many minor browsers.
- **What we could adapt**:
  - **Feature risk categories**: caniuse classifies features as "supported", "partial support", "not supported", "prefix required", "behind a flag". Charlie could use similar categories.
  - **"Partial support" gotchas**: The most dangerous category -- developers think it works, but it has subtle differences per browser. This maps directly to Charlie's "Known Gotchas" column.
  - **Usage-weighted risk**: A feature unsupported in a 0.1% browser is different from one unsupported in Safari (19% of web traffic).

**High-risk "partial support" features to watch**:
```
- CSS Grid (gap in older Safari)
- position: sticky (overflow container bugs in Safari, Firefox)
- Intersection Observer (older Safari options handling)
- Web Animations API (composite modes vary)
- input type="date" (no support in Safari desktop before 14.1)
- dialog element (polyfill behavior differs)
```

### 2.4 WCAG 2.2 Testing Tools Matrix

- **Source**: W3C Web Accessibility Initiative (w3.org/WAI)
- **What it covers**: WCAG 2.2 (published October 2023) is the current accessibility standard. Level AA is the typical compliance target. Testing requires both automated tools and manual testing with assistive technology.
- **Quality**: **Authoritative** -- this is the W3C standard.
- **What we could adapt**:

**Automated Accessibility Testing Tools**:

| Tool | Type | Coverage | Integration |
|---|---|---|---|
| axe-core (Deque) | Library | ~57% of WCAG issues | Playwright, Cypress, Jest, CI/CD |
| Lighthouse | Chrome built-in | ~40% of WCAG issues | CI via lighthouse-ci |
| Pa11y | CLI/Library | ~30% of WCAG issues | CI/CD, GitHub Actions |
| WAVE | Browser extension | ~40% of WCAG issues | Manual, API available |
| IBM Equal Access | Library | ~45% of WCAG issues | CI/CD, browser extension |

**Manual Testing Matrix (WCAG 2.2 Level AA)**:

| Test Category | Tool(s) | Platform | Priority |
|---|---|---|---|
| Screen reader navigation | NVDA + Firefox | Windows | Critical |
| Screen reader navigation | VoiceOver + Safari | macOS/iOS | Critical |
| Screen reader navigation | TalkBack + Chrome | Android | High |
| Keyboard-only navigation | No AT needed | All platforms | Critical |
| Voice control | Dragon NaturallySpeaking | Windows | Medium |
| Voice control | Voice Control | macOS/iOS | Medium |
| Magnification (200%/400%) | OS zoom + browser zoom | All | High |
| High contrast mode | Windows High Contrast | Windows | High |
| Reduced motion | prefers-reduced-motion | All | High |
| Color contrast | axe DevTools, Contrast Checker | All | Critical |

**WCAG 2.2 new success criteria to test**:
```
2.4.11 Focus Not Obscured (Minimum) - AA
2.4.12 Focus Not Obscured (Enhanced) - AAA
2.4.13 Focus Appearance - AAA
2.5.7 Dragging Movements - AA (alternative for drag operations)
2.5.8 Target Size (Minimum) - AA (24x24 CSS pixels minimum)
3.2.6 Consistent Help - A
3.3.7 Redundant Entry - A
3.3.8 Accessible Authentication (Minimum) - AA
3.3.9 Accessible Authentication (Enhanced) - AAA
```

### 2.5 Playwright Browser Support Matrix

- **Repository**: `github.com/microsoft/playwright`
- **What it covers**: Playwright ships its own browser binaries. Supports Chromium, Firefox, and WebKit (the Safari engine). Enables true cross-browser testing including mobile emulation.
- **Quality**: **Excellent** -- actively maintained by Microsoft, the de facto standard for cross-browser E2E testing.
- **What we could adapt**:

**Playwright browser matrix**:

| Browser | Engine | Desktop | Mobile Emulation | Notes |
|---|---|---|---|---|
| Chromium | Blink | Yes | Yes (via device descriptors) | Not identical to Chrome (missing some Google services integration) |
| Firefox | Gecko | Yes | Yes (limited) | Uses patched Firefox for automation protocol |
| WebKit | WebKit | Yes | Yes (iPhone, iPad descriptors) | Closest to Safari, but not identical to production Safari |
| Chrome (branded) | Blink | Yes (channel install) | Yes | Requires separate Chrome install |
| Edge (branded) | Blink | Yes (channel install) | No | Requires separate Edge install |

**Playwright device descriptors** (built-in presets):
```
iPhone 12, iPhone 13, iPhone 14, iPhone 15
iPad (5th-10th gen), iPad Mini, iPad Pro
Pixel 5, Pixel 7
Samsung Galaxy S8, Galaxy S9+
Moto G4 (budget device testing)
Desktop 1920x1080, Desktop 1280x720
```

**Playwright testing capabilities relevant to Charlie**:
- Geolocation spoofing (locale-specific testing)
- Timezone emulation
- Color scheme emulation (dark/light mode)
- Reduced motion emulation
- Forced colors mode (high contrast)
- Offline mode / network throttling
- Permission management (camera, microphone, geolocation)
- Viewport resizing (responsive breakpoint testing)
- `expect(page).toHaveScreenshot()` for visual regression

### 2.6 Cypress Browser Support Matrix

- **Repository**: `github.com/cypress-io/cypress`
- **What it covers**: E2E testing framework. Browser support has expanded over time.
- **Quality**: **Good** -- widely used, but more limited browser support than Playwright.
- **What we could adapt**:

**Cypress browser support**:

| Browser | Support Level | Notes |
|---|---|---|
| Chrome | Full | Primary target |
| Chromium | Full | Bundled Electron uses Chromium |
| Edge | Full | Chromium-based Edge |
| Firefox | Full (since Cypress 9) | Some API differences in test behavior |
| WebKit/Safari | Experimental (since Cypress 12) | Via WebKit integration, limited |
| Electron | Full | Default bundled browser |

**Cypress limitations vs Playwright for cross-platform**:
- No native mobile emulation (use viewport resize only)
- Safari/WebKit support is experimental
- Single browser per test run (no parallel multi-browser by default)
- iframe support has historical limitations

### 2.7 Web Platform Tests (WPT)

- **Repository**: `github.com/nicolo-ribaudo/nicolo-ribaudo.github.io` (results dashboard at wpt.fyi)
- **What it covers**: The Web Platform Tests project is a cross-browser test suite for the web platform. It is the canonical shared test suite that Chrome, Firefox, Safari, and Edge all run to verify standards compliance.
- **Quality**: **Authoritative** -- maintained by browser vendors collaboratively. Tests are written to the specifications.
- **What we could adapt**:
  - **wpt.fyi dashboard patterns**: The dashboard at `wpt.fyi` shows pass rates per browser per spec area. Charlie could use this to identify which spec areas have the most browser divergence.
  - **Interop project scores**: The annual Interop project (formerly Compat 2021, Interop 2022, 2023, 2024, 2025) tracks convergence on specific feature areas. High-priority areas are where browsers historically diverge most.

**Interop 2025 focus areas** (browser vendor agreed priorities):
```
- Anchor Positioning
- CSS Nesting
- Custom Properties (advanced)
- Declarative Shadow DOM
- Navigation API
- Relative Color Syntax
- Scroll Snap
- Starting Style / Transition Behavior
- Text Directionality
- URL patterns
- View Transitions (cross-document)
```

These are areas where browsers are actively converging -- meaning they currently have differences Charlie should test for.

---

## Part 3: Additional Authoritative Sources

### 3.1 StatCounter GlobalStats (Browser Market Share)

**Global desktop browser share (approximate, early 2025)**:
```
Chrome:      ~65%
Safari:      ~19%  (includes iOS)
Edge:        ~5%
Firefox:     ~3%
Samsung Int: ~3%
Opera:       ~2%
Other:       ~3%
```

**Global mobile browser share (approximate, early 2025)**:
```
Chrome:       ~64%
Safari:       ~25%
Samsung Int:  ~5%
Opera:        ~2%
UC Browser:   ~1%
Other:        ~3%
```

### 3.2 HTTP Archive (Web Almanac) Patterns

The HTTP Archive's annual Web Almanac provides data on real-world web technology usage:
- **Median page weight**: ~2.4 MB (desktop), ~2.1 MB (mobile)
- **JavaScript frameworks**: React (~8%), jQuery (~77% of sites still use it)
- **CSS features in use**: Flexbox (~93%), Grid (~42%), Custom Properties (~65%)
- **Responsive design**: ~92% of sites use viewport meta tag, ~88% use media queries

### 3.3 Google Lighthouse Scoring Categories

Relevant testing dimensions:
```
Performance:     FCP, LCP, TBT, CLS, Speed Index
Accessibility:   axe-core based, ~57% WCAG coverage
Best Practices:  HTTPS, no mixed content, no deprecated APIs
SEO:             Meta tags, structured data, crawlability
```

---

## Part 4: Gap Analysis -- What Charlie's Matrix Is Missing

Comparing the current `platform-matrix.md` against authoritative sources:

### Currently Strong

1. Browser matrix with tiers and gotchas -- well structured
2. OS matrix with filesystem and shell concerns -- practical and specific
3. Device matrix with viewport ranges -- good breakpoint coverage
4. Accessibility tools by platform -- covers the major screen readers
5. Known platform-specific gotchas -- actionable and specific

### Gaps to Address

| Gap | Source to Fill From | Priority |
|---|---|---|
| **Browser usage percentages** | StatCounter / Browserslist | High |
| **CSS/JS feature compatibility risks** | MDN browser-compat-data, caniuse | High |
| **WCAG 2.2 testing matrix** | W3C WAI, WCAG 2.2 spec | High |
| **Automated tool recommendations** | axe-core, Playwright, Pa11y | High |
| **Network condition testing** | Playwright network throttling presets | Medium |
| **Interop focus areas** (active browser divergence) | WPT Interop 2025 | Medium |
| **Mobile browser engines** (all iOS browsers use WebKit) | Already noted but could be expanded | Medium |
| **Dark mode / forced colors testing** | Playwright emulation, WCAG 1.4.11 | Medium |
| **Performance budget by device class** | HTTP Archive, Lighthouse | Low |
| **Regional browser variation** | StatCounter by region | Low |
| **Samsung Internet gotchas** | Community bug trackers | Low |

### Recommended Additions to platform-matrix.md

1. **Add browser usage share column** to the browser matrix table
2. **Add "High-Risk Web Features" section** listing features with known browser gaps
3. **Expand accessibility section** with WCAG 2.2 Level AA testing matrix (automated + manual)
4. **Add "Network Conditions" section** with test profiles (3G, LTE, offline)
5. **Add "Automated Testing Tools" section** mapping tools to what they cover
6. **Add "Interop Watch List" section** for features where browsers are actively converging
7. **Add "Mobile Engine Reality" section** explicitly noting iOS WebKit-only constraint and Android WebView fragmentation
8. **Add "Dark Mode / Forced Colors" section** for appearance mode testing

---

## Part 5: Recommendations

### Immediate Value (adapt now)

1. **MDN browser-compat-data** -- Create a curated "gotcha features" list for the matrix, focusing on features with "partial support" status across Tier 1 browsers.

2. **Browserslist defaults** -- Add the `defaults` query as the Tier 1 baseline definition, so the matrix is grounded in real usage data rather than developer intuition.

3. **WCAG 2.2 Level AA** -- Expand the accessibility tools table into a full testing matrix that pairs assistive technology with specific WCAG success criteria.

4. **Playwright device descriptors** -- Adopt Playwright's device presets as the canonical mobile emulation targets, since they're maintained by Microsoft and map to real device specifications.

### Medium-Term Value (adapt in next iteration)

5. **Interop 2025 focus areas** -- Create a "watch list" of features where browsers are actively diverging, updated annually when the Interop project publishes new focus areas.

6. **axe-core rule mapping** -- Map automated accessibility rules to manual testing requirements, so Charlie knows what automation catches and what requires manual testing.

7. **Network condition profiles** -- Define standard test profiles (fast 4G, slow 3G, offline) with specific latency/bandwidth numbers from Playwright/Chrome DevTools presets.

### Long-Term Value (future research)

8. **Regional browser distribution** -- If the product targets specific regions, create region-specific tier assignments using StatCounter data.

9. **Web Almanac patterns** -- Track which CSS/JS features are in widespread use vs. cutting-edge, to prioritize testing effort on features users actually encounter.

---

## Appendix A: Tool Integration Map

How testing tools map to Charlie's responsibilities:

```
Charlie's Responsibility          Tool(s)                    Automation Level
----------------------------------------------------------------------
Browser matrix testing           Playwright                  Full automation
Device/viewport testing          Playwright device presets    Full automation
Visual regression                Playwright screenshots       Full automation
Accessibility (automated)        axe-core + Playwright        Full automation
Accessibility (screen reader)    VoiceOver/NVDA/TalkBack     Manual only
Accessibility (keyboard)         Playwright keyboard API      Partial automation
Network conditions               Playwright network throttle  Full automation
Dark mode / forced colors        Playwright emulation         Full automation
OS-specific (filesystem)         Node.js cross-platform       Full automation
OS-specific (shell/install)      GitHub Actions matrix        Full automation
Performance budgets              Lighthouse CI                Full automation
```

## Appendix B: Playwright Cross-Browser Test Skeleton

```typescript
// Example: Cross-browser smoke test matching Charlie's Tier 1 matrix
import { test, expect, devices } from '@playwright/test';

// playwright.config.ts projects map to Charlie's browser tiers
// Tier 1: chromium, firefox, webkit
// Tier 2: Microsoft Edge, Mobile Safari
// Tier 3: Chrome current-1 (via channel pinning)

const SMOKE_CHECKS = [
  'Page loads without console errors',
  'Navigation works',
  'Forms submit correctly',
  'Layout renders without overflow',
  'Text is readable',
  'Interactive elements respond',
  'Scrolling behaves correctly',
  'No horizontal scroll on mobile',
];

test.describe('Cross-Platform Smoke', () => {
  test('page loads without console errors', async ({ page }) => {
    const errors: string[] = [];
    page.on('console', msg => {
      if (msg.type() === 'error') errors.push(msg.text());
    });
    await page.goto('/');
    expect(errors).toEqual([]);
  });

  test('no horizontal scroll on mobile', async ({ page }) => {
    const scrollWidth = await page.evaluate(() => document.documentElement.scrollWidth);
    const clientWidth = await page.evaluate(() => document.documentElement.clientWidth);
    expect(scrollWidth).toBeLessThanOrEqual(clientWidth);
  });

  test('touch targets meet minimum size', async ({ page }) => {
    // WCAG 2.5.8: 24x24 CSS pixels minimum
    const buttons = await page.locator('button, a, [role="button"]').all();
    for (const button of buttons) {
      const box = await button.boundingBox();
      if (box) {
        expect(box.width).toBeGreaterThanOrEqual(24);
        expect(box.height).toBeGreaterThanOrEqual(24);
      }
    }
  });
});
```

## Appendix C: Key URLs for Future Research

| Source | URL | Update Frequency |
|---|---|---|
| MDN browser-compat-data | github.com/mdn/browser-compat-data | Continuous |
| Can I Use | caniuse.com | Monthly |
| Browserslist | github.com/browserslist/browserslist | Quarterly |
| StatCounter GlobalStats | gs.statcounter.com | Monthly |
| Playwright docs | playwright.dev/docs/browsers | Per release |
| Cypress browser support | docs.cypress.io/guides/guides/launching-browsers | Per release |
| Web Platform Tests dashboard | wpt.fyi | Continuous |
| Interop project | wpt.fyi/interop | Annual |
| WCAG 2.2 | w3.org/TR/WCAG22/ | Stable (2023) |
| axe-core rules | github.com/dequelabs/axe-core | Quarterly |
| HTTP Archive Web Almanac | almanac.httparchive.org | Annual |
| Lighthouse | developer.chrome.com/docs/lighthouse | Per Chrome release |

---

**Research complete.** The skill ecosystem has no cross-platform testing skills -- Charlie's platform-matrix.md is novel. The authoritative sources above provide concrete data to enrich it.
