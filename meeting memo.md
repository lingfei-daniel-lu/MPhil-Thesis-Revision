# 2022.11.3

Discussion about future topics: 

- Trading firm's heterogeneous response to shocks
- Read job market candidate papers from top universities in recent years

- Three popular areas: production network, global value chain, multinational enterprise

# 2022.11.11

This week's task on thesis:

1. combine literature review into the introduction
2. contribute to more streams of literature (at least 3)

Discussion about future topics: 

- within-firm resource allocation across markets and exchange rate shocks
- probability estimation of market entry or exit
- product scope adjustment of multi-product firms

# 2022.11.17

Further modifications of literature review:

1. Separate the review of credit constraints literature into two parts: most related papers about credit constraints and exchange rate pass-through, and general literature about credit constraints and international trade.
2. Directly specify the contribution at the beginning of each paragraph. Then describe the most related papers and explain details about our innovation (evidence or method) compared to them.
3. Give positive or complimentary descriptions of previous paper contributions, especially those written by potential reviewers.

Suggested changes to the main content:

1. For main point 1, the difference between the average levels of import and export exchange pass-through in China could be regarded as a motivating fact rather than one of our main findings.
2. For main point 2, we should try to focus more on the difference between effects of credit constraints on import ERPT and export ERPT and the linkage between credit constraints and import bargaining power (sourcing capacity?)
3. For main point 3, the number of import markets would be more strictly described as the import source base rather than import source diversity.
4. Run more tests about effects of credit constraints on ERPT and import market power:
   1. using market share (mean-cutting subsamples or dummy variable, firm-product-country-year level)
   2. using sourcing diversity (value-weighted measure of import sources, firm-year level) 
   3. using trade distance (between China and import sources, country level)
   4. using new importer indicator (dummy variable, firm-year level or firm-country-year level)

# 2022.11.24

Two specifications with market share and credit constraints:

1. $$
   \Delta \ln p_{ijct}=\alpha+\beta_{1} \Delta \ln RER_{ct}+\beta_{2} \Delta \ln RER_{ct} * Credit_{j}+\beta_{3} \Delta \ln RER_{ct} * Credit_{j}*MS_{ijct}+...
   $$

2. $$
   \Delta \ln p_{ijct}=\alpha+\beta_{1} \Delta \ln RER_{ct}+\beta_{2} \Delta \ln RER_{ct} * MS_{ijct}+\beta_{3} \Delta \ln RER_{ct} * Credit_{j}*MS_{ijct}+...
   $$

Three more tests to explain how credit constraints affect importers' sourcing power:

1. long-run vs short-run relationship: import duration
2. scale effect: market share
3. diversity of network: number of sources, concentration ratio
4. distance effect: geographical distance from CEPII
