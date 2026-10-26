// ============================================================================
// GS Operational System — Name Finder engine
// Matches free-text product descriptions (a supplier's line, a demo-stock
// row) against the Golf Solutions product master, and proposes a name and
// SKU in the house convention for anything the master does not have.
//
// Pure functions, no DOM, no network: app.js hands it the master list and
// the lines and shows what comes back. Kept separate so it can be tested on
// its own.
// ============================================================================
(function () {
  "use strict";

  // ---- vocabulary -------------------------------------------------------------
  const COLOURS = {
    BLACK: "BLK", BLK: "BLK", BLUE: "BLU", BLU: "BLU", RED: "RED", GREEN: "GRN", GRN: "GRN",
    ORANGE: "ORG", ORG: "ORG", WHITE: "WHT", WHT: "WHT", GOLD: "GLD", GLD: "GLD", SILVER: "SLV",
    SLV: "SLV", GREY: "GRY", GRAY: "GRY", GRY: "GRY", CHROME: "CHR", CHR: "CHR", PINK: "PNK",
    NAVY: "NVY", YELLOW: "YLW", PURPLE: "PRP", COPPER: "CPPR", BRONZE: "BRZ",
  };
  const COLOUR_NAME = { BLK: "BLACK", BLU: "BLUE", RED: "RED", GRN: "GREEN", ORG: "ORANGE", WHT: "WHITE",
    GLD: "GOLD", SLV: "SILVER", GRY: "GREY", CHR: "CHROME", PNK: "PINK", NVY: "NAVY", YLW: "YELLOW",
    PRP: "PURPLE", CPPR: "COPPER", BRZ: "BRONZE" };
  const FLEX = new Set(["L", "A", "R", "R1", "R2", "SR", "S", "X", "TX", "LS", "M0", "M1", "M2", "M3", "M4",
    "5.5", "6.0", "6.5", "7.0", "R+", "S+", "X+", "STIFF", "REGULAR", "SENIOR", "LADIES", "LADY", "EXTRA"]);
  const FLEX_WORD = { STIFF: "S", REGULAR: "R", SENIOR: "A", LADIES: "L", LADY: "L", EXTRA: "X" };
  const CAT_WORDS = [
    // longer phrases first so "FW HEAD-SOLE" wins over "FW HEAD"
    ["FW HEAD-SOLE", /\b(FW|FAIRWAY)\s*(WOOD)?\s*HEAD[- ]SOLE\b/], ["FW HEAD-BODY", /\b(FW|FAIRWAY)\s*(WOOD)?\s*HEAD[- ]BODY\b/],
    ["DRIVER HEAD-BODY", /\bDRIVER\s*HEAD[- ]BODY\b/], ["MINI DRIVER", /\bMINI\s*DRIVER\b/],
    ["SHAFT DRIVER", /\bSHAFT\s*(DRIVER|DRV|WOOD|DR)\b|\b(DRIVER|DR|WOOD)\s*SHAFT\b/],
    ["SHAFT FW", /\bSHAFT\s*(FW|FAIRWAY)\b|\b(FW|FAIRWAY)\s*SHAFT\b/],
    ["SHAFT HYBRID", /\bSHAFT\s*(HYBRID|HYB|UT)\b|\b(HYBRID|HYB|UT)\s*SHAFT\b/],
    ["SHAFT IRON", /\bSHAFT\s*IRONS?\b|\bIRONS?\s*SHAFTS?\b/], ["SHAFT PUTTER", /\bSHAFT\s*PUTTER\b|\bPUTTER\s*SHAFT\b/],
    ["DRIVER HEAD", /\bDRIVER\s*HEAD\b|\bHEAD\s*(ONLY\s*)?DRIVER\b|\bDRIVER\b/],
    ["FW HEAD", /\b(FW|FAIRWAY)\s*(WOOD)?\s*HEAD\b|\bFAIRWAY\b|\b\d{1,2}W\b/],
    ["HYBRID HEAD", /\bHYBRID\s*HEAD\b|\bHYBRID\b|\b\d[HU]\b/], ["IRON HEAD", /\bIRON\s*HEAD\b|\bIRONS?\b/],
    ["WEDGE HEAD", /\bWEDGE\b/], ["PUTTER GRIP", /\bPUTTER\s*GRIP\b/], ["GRIP", /\bGRIP\b/],
    ["PUTTER", /\bPUTTER\b/], ["GOLF BAG", /\bBAG\b/], ["GLOVE", /\bGLOVE\b/], ["COMPONENT", /\b(ADAPTOR|ADAPTER|SLEEVE|SHIM|FERRULE|TIP)\b/],
  ];
  const CAT_PREFIX = { "SHAFT IRON": "SI", "IRON HEAD": "HI", "SHAFT DRIVER": "SF", "SHAFT HYBRID": "SH", GRIP: "GR",
    "FW HEAD": "HF", "WEDGE HEAD": "HW", "DRIVER HEAD": "HD", "HYBRID HEAD": "HH", "SHAFT FW": "SF", "SHAFT PUTTER": "SP",
    "FW HEAD-SOLE": "HFS", COMPONENT: "CO", "GOLF BAG": "BG", "FW HEAD-BODY": "HFB", "PUTTER GRIP": "GP", GLOVE: "GL",
    "DRIVER HEAD-BODY": "HDB", PUTTER: "PT", "MINI DRIVER": "HM", ACCESSORY: "AC" };
  const NOISE = new Set(["SHAFT", "SHAFTS", "HEAD", "HEADS", "ONLY", "DRIVER", "FW", "FAIRWAY", "WOOD", "WOODS", "HYBRID",
    "IRON", "IRONS", "WEDGE", "PUTTER", "GRIP", "GRIPS", "GOLF", "BAG", "GLOVE", "COMPONENT", "ADAPTOR", "SLEEVE",
    "DEMO", "NEW", "PCS", "PC", "QTY", "RH", "LH", "FLEX", "GRAM", "G", "GR", "THE", "AND", "WITH", "/", "-", "X", "SET", "UNIT"]);

  const norm = (s) => String(s || "").toUpperCase().replace(/[’'"]/g, "").replace(/[^A-Z0-9.#+\/]+/g, " ").replace(/\s+/g, " ").trim();
  const tokens = (s) => norm(s).split(" ").filter(Boolean);

  // ---- attributes: what sits inside "( ... )" on a master name, or anywhere in a line ----
  function readAttrs(text, cat) {
    const a = {};
    const t = norm(text);
    let m;
    if ((m = t.match(/\b([LR]H)\b/))) a.hand = m[1];
    if ((m = t.match(/\b(\d{1,2})\s*W\b/)) && !/SHAFT/.test(cat || "")) a.wood = m[1] + "W";
    if ((m = t.match(/\bHW\b/))) a.wood = "HW";
    if ((m = t.match(/\b(\d)\s*[HU]\b/)) && /HYBRID/.test(cat || "")) a.hybrid = m[1] + "H";
    if ((m = t.match(/#\s*(\d{1,2}|[PASGLW]W?|W)\b/))) a.iron = m[1].replace(/^(\w)W$/, "$1W");
    if ((m = t.match(/\bW#\s*([\d\/]+)/))) a.woodno = "W" + m[1].replace("/", "");
    // loft: 9.0 / 10.5 / 12 / "5/18" (wood/loft) / wedge 50-64
    if ((m = t.match(/\b(\d{1,2})\s*\/\s*(\d{2}(?:\.\d)?)\b/))) { a.wood = a.wood || m[1] + "W"; a.loft = m[2]; }
    else if ((m = t.match(/\b(\d{1,2}\.\d)\b/))) a.loft = m[1];
    else if (/WEDGE/.test(cat || "") && (m = t.match(/\b(4[6-9]|5\d|6[0-4])\b/))) a.loft = m[1];
    else if (/DRIVER HEAD|FW HEAD|HYBRID HEAD/.test(cat || "") && (m = t.match(/\b(8|9|10|11|12|13|14|15|16|17|18|19|2[0-9])\b(?!\s*W)/))) a.loft = m[1];
    // weight: 40-140, optionally "g", or a shaft family number like DI-5 / "5 S" / 5S
    if ((m = t.match(/\b(\d{2,3})\s*G\b/))) a.weight = m[1];
    else if (/SHAFT/.test(cat || "") && (m = t.match(/\b(3\d|4\d|5\d|6\d|7\d|8\d|9\d|1[0-3]\d)\b(?!\.\d)/))) a.weight = m[1];
    if (/SHAFT/.test(cat || "") && !a.weight && (m = t.match(/\b([A-Z]{2,4})\s?([4-9])\b(?!\.\d)/))) a.weight = m[2];
    if (/SHAFT/.test(cat || "") && !a.weight && (m = t.match(/(?:^|\s)([4-9])(?=\s|$)/))) a.weight = m[1];
    // flex: a standalone flex token, or glued to a weight class ("5S", "6X", "70S")
    const flexText = norm(String(text || "").toUpperCase().replace(/\b[A-Z]{1,2}-[A-Z]{3,}\b/g, " ").replace(/\b[A-Z]{3,}-[A-Z]{1,2}\b/g, " "));
    for (const tok of flexText.split(" ")) {
      const f = tok.toUpperCase();
      if (FLEX.has(f)) { a.flex = FLEX_WORD[f] || f; break; }
      const g = f.match(/^(\d{1,3})(R1|SR|TX|LS|R|S|X|A|L)$/);
      if (g) { a.flex = g[2]; if (!a.weight) a.weight = g[1]; break; }
    }
    for (const tok of t.split(" ")) {
      const c = tok.replace(/\/.*/, "");
      if (COLOURS[c]) { a.colour = COLOURS[c]; break; }
    }
    if (a.loft != null) a.loft = String(parseFloat(a.loft));
    // a bare number on a club line: "QUANTUM MAX 7" is a 7-wood, "G440 3" a 3-hybrid, "APEX 5" a 5-iron
    const bare = (t.match(/(?<![.\/#\d])\b(\d{1,2})\b(?![.\/]\d)(?!\s*[WHUG])/g) || []);
    const last = bare.length ? bare[bare.length - 1] : null;
    if (last && /FW HEAD/.test(cat || "") && !a.wood && !a.loft && /^(3|5|7|9|11|13|15)$/.test(last)) a.wood = last + "W";
    if (last && /HYBRID HEAD/.test(cat || "") && !a.hybrid && !a.loft && /^[2-7]$/.test(last)) a.hybrid = last + "H";
    if (last && /IRON HEAD/.test(cat || "") && !a.iron && /^[3-9]$/.test(last)) a.iron = last;
    return a;
  }
  const ATTR_ORDER = ["wood", "woodno", "hybrid", "iron", "loft", "weight", "flex", "colour", "hand"];
  const attrWord = (k, v) => k === "colour" ? COLOUR_NAME[v] || v : k === "iron" ? "#" + v : v;
  const attrCode = (k, v) => k === "iron" ? v : v;

  // ---- model words: the name with brand, category words and attributes removed ----
  function modelWords(name, brand) {
    let s = norm(name);
    if (brand) s = s.replace(norm(brand), " ");
    s = s.replace(/\([^)]*\)\s*$/, " ");
    return tokens(s).filter((w) => !NOISE.has(w) && !FLEX.has(w) && !COLOURS[w] && !/^\d+(\.\d+)?$/.test(w) && !/^#/.test(w) && !/^\d+[WHU]$/.test(w) && !/^\d+\/\d+$/.test(w) && !/^\d{1,3}(R1|SR|TX|LS|R|S|X|A|L)$/.test(w));
  }
  const abbrev = (w) => (w.length <= 3 ? w : w[0] + w.slice(1).replace(/[AEIOU]/g, "")).slice(0, 5);

  // ---- the index: everything the engine learns from the master ----------------
  function buildIndex(master) {
    const items = master.map((p) => {
      const cat = p.item_category || p.cat || "";
      const brand = p.brand || "";
      const paren = (p.name.match(/\(([^)]*)\)\s*$/) || [])[1] || "";
      const segs = paren ? paren.split("/").map((x) => x.trim()).filter(Boolean) : [];
      return {
        sku: p.sku, name: p.name, brand, cat,
        model: modelWords(p.name, brand),
        attrs: readAttrs(paren || "", cat),
        parenSegs: segs,
        head: p.name.replace(/\s*\([^)]*\)\s*$/, "").trim(),
        skuModel: (p.sku.split("-")[2] || ""),
        brandCode: (p.sku.split("-")[1] || ""),
      };
    });
    const brands = [...new Set(items.map((x) => x.brand).filter(Boolean))].sort((a, b) => b.length - a.length);
    const brandCode = {};
    items.forEach((x) => { if (x.brand && x.brandCode && !brandCode[x.brand]) brandCode[x.brand] = x.brandCode; });
    // a model word that belongs to exactly one brand identifies the brand ("QUANTUM" → CALLAWAY)
    const wordBrands = {};
    items.forEach((x) => x.model.forEach((w) => { (wordBrands[w] = wordBrands[w] || new Set()).add(x.brand); }));
    const brandByWord = {};
    Object.entries(wordBrands).forEach(([w, set]) => { if (set.size === 1 && w.length >= 3) brandByWord[w] = [...set][0]; });
    return { items, brands, brandCode, brandByWord };
  }

  function detectBrand(line, idx) {
    const t = norm(line);
    for (const b of idx.brands) if (t.includes(norm(b))) return b;
    const ALIAS = { "TOUR AD": "GRAPHITE DESIGN", "GD": "GRAPHITE DESIGN", "MITSUBISHI": "MITSUBISHI CHEMICAL", "TM": "TAYLORMADE",
      "NIPPON": "NIPPON SHAFT", "N.S.PRO": "NIPPON SHAFT", "NS PRO": "NIPPON SHAFT", "MODUS": "NIPPON SHAFT", "DG": "TRUE TEMPER",
      "DYNAMIC GOLD": "TRUE TEMPER", "GOLFPRIDE": "GOLF PRIDE", "STEELFIBER": "AEROTECH" };
    for (const [k, v] of Object.entries(ALIAS)) if (t.includes(k) && idx.brands.includes(v)) return v;
    for (const w of tokens(t)) if (idx.brandByWord[w]) return idx.brandByWord[w];
    return "";
  }
  function detectCategory(line, hint) {
    const t = norm(line);
    for (const [cat, re] of CAT_WORDS) if (re.test(t)) return cat;
    return hint || "";
  }

  // ---- scoring one master item against one line --------------------------------
  // A line names a product the way a supplier or a stock sheet does — fewer
  // words and fewer attributes than the master. So the test is one-way: every
  // model word and every attribute ON THE LINE must be found on the item; the
  // item may carry more (a flex, a hand) and still be the same product.
  const NON_CLUB = new Set(["COMPONENT", "ACCESSORY", "GOLF BAG", "GLOVE"]);
  const wordHit = (w, list) => list.includes(w) || list.some((m) => m.length >= 4 && w.length >= 4 && (m.startsWith(w) || w.startsWith(m)));
  function score(item, L) {
    let s = 0;
    if (L.brand && item.brand === L.brand) s += 3; else if (L.brand && item.brand) s -= 4;
    if (L.cat) { if (item.cat === L.cat) s += 2; else if (item.cat.split(" ")[0] !== L.cat.split(" ")[0]) s -= 3; }
    else if (NON_CLUB.has(item.cat)) s -= 3;
    const covered = L.model.filter((w) => wordHit(w, item.model));
    const cover = L.model.length ? covered.length / L.model.length : (item.model.length ? 0 : 1);
    const extraItem = item.model.filter((w) => !wordHit(w, L.model));
    s += cover * 6 - Math.min(extraItem.length, 4) * 0.4;
    const diff = [];
    let same = 0, lineOnly = 0, masterOnly = 0, clash = 0;
    for (const k of ATTR_ORDER) {
      const a = L.attrs[k], b = item.attrs[k];
      if (a != null && b != null) {
        if (String(a) === String(b)) { s += 1.5; same++; } else { s -= 3; clash++; diff.push(`${k} ${attrWord(k, a)}≠${attrWord(k, b)}`); }
      } else if (a != null) { s -= 1.5; lineOnly++; diff.push(`${k} ${attrWord(k, a)} only on the line`); }
      else if (b != null) { s -= 0.3; masterOnly++; diff.push(`${k} only in master`); }
    }
    const modelDiff = [...L.model.filter((w) => !covered.includes(w)).map((w) => w + " (line)"), ...extraItem];
    const exact = cover >= 0.99 && clash === 0 && lineOnly === 0 && (!L.brand || item.brand === L.brand);
    return { s, modelScore: cover, same, diff, modelDiff, exact, masterOnly };
  }

  // ---- build a proposal in the house convention -----------------------------------
  function propose(L, sibling, idx) {
    const cat = L.cat || (sibling && sibling.cat) || "";
    const brand = L.brand || (sibling && sibling.brand) || "";
    const prefix = CAT_PREFIX[cat] || (sibling ? sibling.sku.split("-")[0] : "XX");
    const bcode = idx.brandCode[brand] || abbrev(norm(brand).replace(/ /g, "")).slice(0, 3) || "GEN";
    // attribute slots: follow the sibling's order, then anything it lacks
    let order = [];
    if (sibling) {
      sibling.parenSegs.forEach((seg) => {
        const a = readAttrs(seg, cat); const k = ATTR_ORDER.find((x) => a[x] != null);
        if (k && !order.includes(k)) order.push(k);
      });
    }
    ATTR_ORDER.forEach((k) => { if (L.attrs[k] != null && !order.includes(k)) order.push(k); });
    const segs = order.filter((k) => L.attrs[k] != null).map((k) => attrWord(k, L.attrs[k]));
    const codes = order.filter((k) => L.attrs[k] != null).map((k) => attrCode(k, L.attrs[k]));
    let head, modelCode;
    if (sibling) { head = sibling.head; modelCode = sibling.skuModel; }
    else {
      const model = L.model.length ? L.model : L.words.filter((w) => !NOISE.has(w)).slice(0, 4);
      head = [brand, cat, ...model].filter(Boolean).join(" ");
      modelCode = model.map(abbrev).join("").slice(0, 12) || "GEN";
    }
    return { name: segs.length ? `${head} (${segs.join(" / ")})` : head, sku: [prefix, bcode, modelCode, ...codes].join("-"), brand, cat };
  }

  // ---- one line ----------------------------------------------------------------------
  function analyzeLine(raw, idx, hint) {
    const text = String(raw || "").trim();
    const brand = detectBrand(text, idx);
    const cat = detectCategory(text, hint && hint.cat);
    const attrs = readAttrs(text, cat);
    const words = tokens(text);
    let L = { text, brand, cat, attrs, words, model: modelWords(text, brand) };
    // ties: the master often holds the same head with and without a hand
    // ("10.5" and "10.5 / RH") — the fully specified one is the stock item
    const handy = (r, it) => (it.attrs.hand && r.diff.some((d) => d.startsWith("hand only in master")) ? 0 : 1);
    const rank = (LL) => idx.items.map((it) => ({ it, r: score(it, LL) }))
      .sort((a, b) => b.r.s - a.r.s || handy(a.r, a.it) - handy(b.r, b.it) || a.r.masterOnly - b.r.masterOnly);
    let scored = rank(L);
    if (!cat && scored[0] && scored[0].r.s > 3) {
      const guess = scored[0].it.cat;
      L = { ...L, cat: guess, attrs: readAttrs(text, guess) };
      scored = rank(L);
    }
    const top = scored.slice(0, 3);
    const best = top[0];
    const nearest = top.map(({ it, r }) => ({
      sku: it.sku, name: it.name, score: Math.round(r.s * 10) / 10,
      differs: [r.modelDiff.length ? "model: " + r.modelDiff.join("/") : "", ...r.diff].filter(Boolean).join("; ") || "same",
    }));
    if (best && best.r.exact && best.r.s >= 6) {
      return { text, status: "in master", sku: best.it.sku, name: best.it.name, brand: best.it.brand, cat: best.it.cat, nearest, confidence: best.r.s };
    }
    // same model, different spec → a sibling to copy the pattern from
    const sib = best && best.r.modelScore >= 0.66 && best.r.s > 2 && (!L.brand || best.it.brand === L.brand) ? best.it : null;
    const p = propose(L, sib, idx);
    return { text, status: sib ? "NEW" : "unknown", sku: p.sku, name: p.name, brand: p.brand, cat: p.cat, nearest, confidence: best ? best.r.s : 0 };
  }

  // "desc", "desc<TAB>qty", "qty<TAB>desc", "2 x desc", "desc x2"
  function parseLines(text) {
    return String(text || "").split(/\r?\n/).map((l) => l.trim()).filter(Boolean).map((l) => {
      let qty = 1, desc = l;
      const cells = l.includes("\t") ? l.split("\t").map((c) => c.trim()) : null;
      if (cells) {
        const qi = cells.findIndex((c) => /^\d{1,3}$/.test(c));
        if (qi > -1) { qty = Number(cells[qi]); cells.splice(qi, 1); }
        desc = cells.filter(Boolean).join(" | ");
      } else {
        let m;
        if ((m = l.match(/^(\d{1,3})\s*[x×]\s+(.+)$/i))) { qty = Number(m[1]); desc = m[2]; }
        else if ((m = l.match(/^(.+?)\s+[x×]\s*(\d{1,3})$/i))) { qty = Number(m[2]); desc = m[1]; }
      }
      return { qty, desc };
    });
  }

  window.GS_NAMES = { buildIndex, analyzeLine, parseLines, readAttrs, detectBrand, detectCategory, CAT_PREFIX };
})();
