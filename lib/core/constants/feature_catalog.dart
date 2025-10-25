import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeatureDescriptor {
  const FeatureDescriptor({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

const List<FeatureDescriptor> kProTradingFeatures = [
  FeatureDescriptor(
    icon: FontAwesomeIcons.chartLine,
    title: 'Real-time Heatmaps',
    subtitle: 'Track sector rotation with auto-refreshing visuals.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.robot,
    title: 'AI Trend Radar',
    subtitle: 'Detect unusual momentum using on-device models.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.rankingStar,
    title: 'Alpha Scorecards',
    subtitle: 'Blend technical + fundamental KPIs into one badge.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.scaleBalanced,
    title: 'Portfolio Hedging Coach',
    subtitle: 'Simulate hedge ratios across correlated assets.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.bullseye,
    title: 'Price Targets Ladder',
    subtitle: 'Layer multi-level TP/SL targets with risk notes.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.clockRotateLeft,
    title: 'Event Replay',
    subtitle: 'Rewind intraday tape with annotated catalysts.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.circleNodes,
    title: 'Correlation Matrix',
    subtitle: 'Discover diversification gaps instantly.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.magnifyingGlassChart,
    title: 'Deep Search',
    subtitle: 'Find tickers by theme, metric or natural language.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.layerGroup,
    title: 'Multi-Portfolio Views',
    subtitle: 'Switch between cash, margin and demo instantly.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.handHoldingDollar,
    title: 'Income Planner',
    subtitle: 'Project dividends and staking yields in both locales.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.chartPie,
    title: 'Allocation Analyzer',
    subtitle: 'Visualize weight drift and rebalance suggestions.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.gaugeHigh,
    title: 'Volatility Thermometer',
    subtitle: 'Monitor realized vs implied vol spreads.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.calendarCheck,
    title: 'Macro Calendar Sync',
    subtitle: 'Overlay FOMC, CPI and earnings on your charts.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.personRunning,
    title: 'Discipline Tracker',
    subtitle: 'Log adherence to playbooks for post-trade review.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.towerObservation,
    title: 'Liquidity Watch',
    subtitle: 'Auto-flag slippage risk across venues.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.chartSimple,
    title: 'Scenario Studio',
    subtitle: 'Stress-test P&L versus macro shocks.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.shieldHalved,
    title: 'Compliance Vault',
    subtitle: 'Store trading notes and export audit trails.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.solidCompass,
    title: 'Strategy Navigator',
    subtitle: 'Follow curated quant or discretionary playbooks.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.arrowTrendUp,
    title: 'Leaders & Laggards',
    subtitle: 'Surface intraday breakouts vs. market baseline.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.moneyBillTrendUp,
    title: 'Smart Cost Averaging',
    subtitle: 'Automate ladder orders with adaptive sizing.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.signal,
    title: 'News Sentiment Pulse',
    subtitle: 'Blend RSS and social feeds with polarity tags.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.chartArea,
    title: 'Order Flow Tapes',
    subtitle: 'Replay block prints and dark pool activity.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.userTie,
    title: 'Advisor Workspace',
    subtitle: 'Share model portfolios securely with clients.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.globe,
    title: 'FX & Metals Radar',
    subtitle: 'Pin spreads and carry scores side by side.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.arrowsSpin,
    title: 'Rotation Alerts',
    subtitle: 'Catch regime shifts with AI-driven detectors.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.sliders,
    title: 'Custom Factor Builder',
    subtitle: 'Mix smart beta signals without coding.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.chartColumn,
    title: 'Earnings Sandbox',
    subtitle: 'Model surprises with consensus delta charts.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.arrowsSplitUpAndLeft,
    title: 'Pairs Trading Lab',
    subtitle: 'Compare co-integration stats for spreads.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.cubesStacked,
    title: 'Tokenomics Explorer',
    subtitle: 'Track unlock schedules and staking emissions.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.chartCandlestick,
    title: 'Advanced Chart Replay',
    subtitle: 'Animate candlesticks with key level callouts.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.chalkboardUser,
    title: 'Coach Notes',
    subtitle: 'Attach journal prompts to every asset.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.lightbulb,
    title: 'Idea Incubator',
    subtitle: 'Save, tag and prioritize trades with AI scoring.',
  ),
  FeatureDescriptor(
    icon: FontAwesomeIcons.tableColumns,
    title: 'Smart Watchlists',
    subtitle: 'Auto-group assets by volatility or sector.',
  ),
];
