info <- c(
  "<strong><u>Rufus Porter</u></strong> was born in West Boxford, Massachusetts in 1792. 
  He spent much of his childhood in the Pleasant Mountain Gore, near what is now 
  Bridgton, Maine. As a young man, he attended Fryeburg Academy, worked as an
  apprentice shoemaker, spent time in the Militia during the War of 1812, and
  became a dancing master. <br>In 1815, Porter began his time as an itinerant 
  portrait painter. He traveled all around New England, painting inexpensive 
  portraits and making hollow-cut silhouettes. <br>By the 1830s, he had expanded his
  artwork to landscape mural painting, which is what he is mostly remembered for
  today. Porter's style consisted of clear colors, a chest-high horizon line, 
  distant mountains, and huge trees in the foreground. Porter is known to have
  directly taught at least two other muralists: his nephew, Jonathan D. Poor, 
  and his son, Stephen Twombly Porter. He also published instructions for his
  landscape mural painting style in his book <em>Curious Arts</em>.",
  "<strong><u>Jonathan D. Poor</u></strong> was born in Sebago, Maine in 1807. It is likely that
  Poor spent the 1820s travelling with his uncle, Rufus Porter, producing painted
  portraits and silhouettes. Based on the dated signatures he left, Poor worked 
  as a mural painter between 1830 and 1842, and likely learned the craft from
  his uncle, although he developed his own style. Poor's murals feature a greater
  variety of colors, detailed hillsides with orchards and fencing, and sumac
  shrubs and red birds in the foreground.",
  "<strong><u>The Rufus Porter School</u></strong> is the term applied to un-signed murals 
  painted in the style of Rufus Porter's murals. There are dozens, if not 
  hundreds, of Porter School murals in New England, which feature common Porter
  motifs, such as trees, fields, boats, and houses. It is likely that the 
  unknown painters of Porter School murals learned from Porter's instructions 
  in <em>Curious Arts</em>.",
  "<strong><u>E.J. Gilbert</u></strong> was a painter of Porter School murals. There is no 
  biographical information available about him, but it is known that Gilbert 
  painted and signed murals in the Knowlton House in Winthrop, ME, at 
  some time during the 1830s. The signature is stenciled, indicating that Gilbert
  planned to create and sign more murals; it is possible that other E.J. Gilbert
  murals have been covered by wallpaper or paint, and have yet to be uncovered.
  The style and motifs of Gilbert's mural indicate that he likely saw some of 
  Rufus Porter and/or J.D. Poor's murals in Maine, as he included images such as 
  red sumac, faux chair rails, and water scenes. <br>
  <br><strong><u>Orison Wood</u></strong> was a muralist active in the Lewiston/Auburn 
  area of Maine in the 1830s. Little is known about him, but he is said to have 
  learned the art of painting on plaster from his father, Solomon Wood, a plaster
  figure maker. <br>
  <br><strong><u>Paine</u></strong> is a mysterious muralist from the Parsonfield, ME area, who 
  may have collaborated with Jonathan D. Poor on some murals during the 1830s. 
  Folk art scholar Jean Lipman cited the motif of an uprooted dead tree resting 
  between the branches of another tree as Paine's signature, but there is little
  other evidence of his existence.<br>
  <br><strong><u>Moses Eaton, Jr.</u></strong> learned the art of wall stenciling from his father,
  Moses Eaton, who was a prolific stenciler in New England in the late-18th and 
  early-19th centuries. Eaton Jr. is less documented than his father, but is 
  believed to have been one of the two young men said to have painted the walls
  of the Joshua Eaton House in Bradford, NH.<br>
  <br><strong><u>Granville Fernald</u></strong> is another mysterious painter suggested by Jean
  Lipman to have painted in the Rufus Porter style. Fernald was recorded as being
  a house and carriage painter in Harrison, ME between 1851 and 1854, and it is 
  possible that two murals painted circa 1850 in the greater Portland, ME area
  were done by Fernald, while Porter was in Washington, DC.<br>
  <br><strong><u>E.V. Bennett</u></strong> signed the murals in the Frank Hanson House in Winthrop, 
  ME. Lipman speculated that he was an assistant to Porter at the time, but no 
  infomation exists to confirm this hypothesis.<br>
  <br>The <strong><u>Bears and Pears</u></strong> Artist is an unidentified painter 
  of murals and fireboards who was active between 1820 and 1830.
  The name comes from a distinctive fireboard, now in the collection of the 
  Fenimore Art Museum in Cooperstown, NY. Linda Carter Lefko and Jane E. Radcliffe
  attribute three murals in New Hampshire to this artist.<br>
  <br><strong><u>Quincy</u></strong> is the name signed on the murals of the 
  Gilmore House in Norridgewock, ME. These murals share many characteristics with 
  Rufus Porter murals, including the distinctive stairway wall featuring men 
  climbing on large rocks and cliffs. It is possible, according to Lefko and 
  Radcliffe, that this artist is Marcus Quincy, who was credited in an 1846 issue
  of the <em>Portland Tribune and Bulletin</em> as being Rufus Porter's painting 
  instructor.<br>
  ")
  
  
creator <- c("rp", 
             "jdp", 
             "school", 
             "other"
             )

artist_info <- data.frame(creator, info)

artist_info %>% write_csv("rpm-map/data/artist_info.csv")