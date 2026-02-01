# Platform Matrix Reference

Living document. Update as platforms evolve and user distribution shifts.

Sources: MDN browser-compat-data, Browserslist, Can I Use, WCAG 2.2, Playwright, Web Platform Tests (Interop 2025).

## Browser Matrix

Test current and current-1 for each. Tiers based on global usage share (StatCounter/Browserslist).

| Browser | Tier | Share | Engine | Known Gotchas |
|---|---|---|---|---|
| Chrome (latest) | 1 | ~65% | Blink | Baseline reference — if it breaks here, it's broken |
| Safari (latest) | 1 | ~19% | WebKit | Date parsing differences, `position: sticky` in overflow, no `beforeunload` on iOS |
| Firefox (latest) | 1 | ~3% | Gecko | Stricter CSP enforcement, different font rendering, stricter CORS preflight |
| Edge (latest) | 2 | ~5% | Blink | Mostly Chrome-compatible; check Edge-specific enterprise features |
| Samsung Internet | 2 | ~3% | Blink | Older Chromium base, check feature gap vs Chrome |
| Safari (current-1) | 2 | — | WebKit | iOS users update slower than desktop; test the previous major |
| Firefox ESR | 3 | — | Gecko | Enterprise and Linux distro default |
| Chrome (current-1) | 3 | — | Blink | Enterprise environments pin versions |

**Tier baseline**: Browserslist `defaults` query (>0.5% global, last 2 versions, Firefox ESR, not dead).

**iOS critical note**: ALL browsers on iOS use WebKit engine regardless of branding. Chrome on iOS = WebKit, not Blink. Test Safari to test all iOS browsers.

## High-Risk Web Features

Features with known browser gaps. Check before using in production.

| Feature | Chrome | Firefox | Safari | Risk |
|---|---|---|---|---|
| View Transitions API | 111+ | Behind flag | No | High — no Safari |
| CSS Nesting | 120+ | 117+ | 17.2+ | Medium — recent adoption |
| Popover API | 114+ | 125+ | 17+ | Medium — Firefox late |
| `Intl.Segmenter` | 87+ | 125+ | 17.4+ | Medium — Firefox very late |
| CSS Container Queries | 105+ | 110+ | 16+ | Low — widely landed |
| CSS `:has()` selector | 105+ | 121+ | 15.4+ | Low — widely landed |
| CSS Subgrid | 117+ | 71+ | 16+ | Low — Firefox had it first |
| WebGPU | 113+ | Behind flag | Preview | High — no stable Firefox/Safari |

### Interop Watch List (2025)

Active browser convergence areas — where browsers are diverging, test extra carefully:

Anchor Positioning, CSS Nesting (advanced), Declarative Shadow DOM, Navigation API, Scroll Snap, View Transitions (cross-document), Starting Style / Transition Behavior.

## OS Matrix

| OS | Tier | Key Concerns |
|---|---|---|
| Windows 10/11 | 1 | Path separators (`\` vs `/`), line endings (CRLF), case-insensitive filesystem, PowerShell vs cmd |
| macOS (latest) | 1 | Gatekeeper, code signing, case-insensitive HFS+ by default |
| iOS (latest) | 1 | All browsers use WebKit engine, viewport handling, safe area insets |
| Android (latest) | 1 | WebView fragmentation, Chrome vs Samsung Internet |
| Ubuntu LTS | 2 | Standard Linux reference, snap vs apt packaging |
| macOS (current-1) | 2 | Users delay OS upgrades |
| Windows Server | 3 | If deploying server-side tools |

## Device Matrix

| Device Type | Viewport Range | Key Concerns |
|---|---|---|
| Mobile (portrait) | 320px - 428px | Touch targets min 24px (WCAG 2.5.8), soft keyboard layout shift, safe areas |
| Mobile (landscape) | 568px - 926px | Notch avoidance, reduced height |
| Tablet (portrait) | 768px - 834px | Split-view on iPad, hover states unavailable |
| Tablet (landscape) | 1024px - 1194px | Often treated as desktop — verify layout holds |
| Desktop | 1280px - 1920px | Mouse/keyboard primary, hover states expected |
| Large desktop | 1920px+ | Content max-width, layout stretch |

## Standard Breakpoints

```
320px  — Small mobile (iPhone SE)
375px  — Standard mobile (iPhone 12/13/14)
428px  — Large mobile (iPhone 14 Pro Max)
768px  — Tablet portrait (iPad)
1024px — Tablet landscape / small desktop
1280px — Desktop
1440px — Large desktop
1920px — Full HD
```

## Network Condition Profiles

Test under constrained conditions, not just developer fast WiFi.

| Profile | Latency | Download | Upload | Use Case |
|---|---|---|---|---|
| Fast 4G | 20ms | 12 Mbps | 6 Mbps | Typical mobile on good signal |
| Slow 3G | 400ms | 500 Kbps | 250 Kbps | Worst-case mobile, rural areas |
| Offline | — | 0 | 0 | Progressive enhancement, service workers |
| Throttled desktop | 50ms | 5 Mbps | 2 Mbps | Corporate VPN, shared connection |

Playwright: `page.route('**/*', route => route.abort())` for offline. Chrome DevTools throttling for other profiles.

## Known Platform-Specific Gotchas

### File Systems
- **Windows**: Case-insensitive, `\` path separators, CRLF line endings, reserved names (CON, PRN, NUL, AUX)
- **macOS**: Case-insensitive by default (HFS+), resource forks, `.DS_Store` files
- **Linux**: Case-sensitive, symlink behavior differences

### Shell & Scripts
- **Windows**: No `sh`/`bash` by default, PowerShell syntax differs, `%VARS%` vs `$VARS`
- **macOS**: zsh default since Catalina, BSD utilities (not GNU)
- **Linux**: bash default, GNU utilities

### Filesystem Atomicity
- **Windows NTFS**: `rename()` is not atomic if target exists — must delete-then-rename or use `MoveFileEx` with `MOVEFILE_REPLACE_EXISTING`
- **Linux ext4/macOS APFS**: `rename()` atomically replaces target

### Browser-Specific
- **Safari**: No `beforeunload` on iOS, different date parsing (`new Date('2024-1-5')` fails), `position: sticky` inside overflow containers
- **Firefox**: Stricter CORS preflight, `scrollbar-width` support differs
- **Chrome Android**: 300ms tap delay unless `<meta name="viewport">` present

## Accessibility Testing Matrix (WCAG 2.2 Level AA)

### Automated (catches ~57% of WCAG issues)

| Tool | Coverage | Integration |
|---|---|---|
| axe-core (Deque) | ~57% | Playwright, Cypress, Jest, CI/CD |
| Lighthouse | ~40% | CI via lighthouse-ci |
| Pa11y | ~30% | CI/CD, GitHub Actions |

### Manual (required for the remaining ~43%)

| Test | Tool | Platform | Priority |
|---|---|---|---|
| Screen reader navigation | NVDA + Firefox | Windows | Critical |
| Screen reader navigation | VoiceOver + Safari | macOS/iOS | Critical |
| Screen reader navigation | TalkBack + Chrome | Android | High |
| Keyboard-only navigation | No AT needed | All | Critical |
| Magnification (200%/400%) | OS zoom + browser zoom | All | High |
| High contrast / forced colors | Windows High Contrast | Windows | High |
| Reduced motion | `prefers-reduced-motion` | All | High |
| Color contrast | axe DevTools | All | Critical |

### WCAG 2.2 New Criteria to Test

- **2.5.8 Target Size (Minimum)** — AA: Interactive targets must be at least 24x24 CSS pixels
- **2.4.11 Focus Not Obscured** — AA: Focused element not fully hidden by sticky headers/modals
- **3.3.8 Accessible Authentication** — AA: No cognitive function test (captcha) without alternative
- **3.3.7 Redundant Entry** — A: Don't make users re-enter info already provided

## Smoke Test Checklist (Per Platform)

- [ ] Page loads without console errors
- [ ] Navigation works (all links, menus)
- [ ] Forms submit correctly
- [ ] Layout renders without overflow/overlap
- [ ] Text is readable (no truncation, no overlap)
- [ ] Interactive elements respond to platform input (touch/mouse/keyboard)
- [ ] Scrolling behaves correctly
- [ ] No horizontal scroll on mobile viewports
- [ ] Touch targets meet 24px minimum (WCAG 2.5.8)
- [ ] Focus visible and not obscured (WCAG 2.4.11)
- [ ] axe-core reports 0 violations
