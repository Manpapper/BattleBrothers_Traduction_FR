local gt = this.getroottable();

if (!("Strings" in gt.Const))
{
	gt.Const.Strings <- {};
}

gt.Const.Strings.PayTavernRoundIntro <- [
"Les hommes acclament ton nom en buvant.",
	"Les hommes boivent aux camarades tombés au combat.",
	"Les hommes acclament le nom de la compagnie en buvant.",
	"Les hommes boivent aux femmes et à leurs poitrines.",
	"Les hommes boivent à la mémoire des fidèles chiens de garde.",
	"Les rires et les histoires légères remplissent la taverne pendant que vos hommes boivent.",
	"La dure vie de mercenaire prend du repos alors que les hommes partagent des histoires de leurs vies passées et s\'amusent.",
	"Hourra au commandant ! crient les hommes.",
	"Vos hommes se vantent de leurs exploits en buvant.",
	"Les boissons fortes estompent pour un temps les horreurs du combat.", "Les hommes applaudissent et portent un toast à la gloire du commandant !",
	"Vos hommes applaudissent et trinquent à la richesse et à une longue vie.",
	"La bière fait disparaître les difficultés de la journée."
];
gt.Const.Strings.PayTavernRumorsIntro <- [
"Les clients crient ton nom en faisant tinter leurs tasses. La boisson leur délie la langue.",
	"Les clients approuvent de la tête.",
	"Les gens lèvent leur chope en signe d\'appréciation.",
	"Les gens murmurent en signe d\'approbation.",
	"L\'aubergiste sonne la cloche pour dire à tout le monde que la prochaine tournée est pour vous."
];
gt.Const.Strings.RumorsLocation <- [
	"Il y a un endroit appelé %location% %terrain% à la %direction% d\'ici. La plupart des gens le connaissent, je pense, mais peu s\'y aventureraient.",
	"%randomname% m\'a parlé de %location% l\'autre jour. Plein de trésors, il a dit, à %distance% %direction% d\'ici. Ou peut-être que je m\'en souviens mal.",
	"Si c\'est l\'aventure que tu cherches, il y a un endroit appelé %location% %terrain% %direction% d\'ici. Je ne sais pas qui y vit de nos jours, par contre.",
	"Tu as entendu parler de %location% ? Les gens disent que c\'est hanté, avec les morts qui marchent et tout ça. Quelque part à %direction% d\'ici. Peut-être que quelqu\'un d\'autre à %nom de la ville% pourra vous en dire plus...",
	"Vous connaissez... Bon sang, comment ça s\'appelle déjà ? Dans la %direction% %distance% d\'ici, %terrain%. Je n\'arrive pas à me rappeler comment on l\'appelait avant...",
	"Vous avez croisé %location% en venant ici ? Pourquoi, c\'est %terrain% dans la %direction%. Quelqu\'un devrait vous engager pour brûler cette chose. Rien de bon ne vient de là, ça c\'est sûr.",
	"Nous avons repéré quelque chose en venant ici, caché loin de la route, %terrain% %distance% %direction% de %nom de la ville%. Je ne sais pas comment les gens du coin l\'appellent, ni même s\'ils le connaissent, mais ça pourrait valoir le coup d\'y retourner."
];
gt.Const.Strings.RumorsContract <- [
	"J\'ai entendu dire que le conseil de %settlement% cherche à engager des mercenaires. Je ne sais pas pour quoi faire.",
	"Un groupe de jeunes gens est parti pour %settlement% il y a quelques jours. Ils cherchent à engager des hommes armés là-bas, prêts à payer très cher. J\'espère juste qu\'ils reviendront vivants.",
	"Si vous cherchez du travail, j\'ai entendu dire qu\'ils embauchaient des mercenaires à %settlement%.",
	"Vous avez entendu dire qu\'ils recrutent des combattants à %settlement% ?",
	"Un gars de %settlement% était là l\'autre jour, il voulait engager des gars forts pour un problème qu\'ils ont là-bas. Je ne pense pas que beaucoup soient allés avec lui, cependant.",
	"Des mercenaires, hein ? On en a un peu ces jours-ci. Il y a quelques jours, une bande qui se faisait appeler %randommercenarycompany% est passée par là. En route pour %settlement%, ils ont dit qu\'il y avait de l\'argent à se faire là-bas.",
	"Si c\'est du travail que tu cherches, ils prennent des couronnes en main à %settlement% pour engager des hommes forts.",
	"J\'ai entendu dire qu\'un gros marchand de %settlement% cherchait à engager des gardes armés l\'autre jour. Eh bien, je ne vais pas mourir pour lui, non merci. Je veux ma maison et ma femme ici."
];
gt.Const.Strings.RumorsGeneral <- [
	"Si tu cherches à obtenir un bon prix pour tes marchandises, mon ami, tu devrais aller dans une grande ville ou un château et pas dans un village pauvre et délabré au cul du monde.",
	"Les boissons à %randomtown% sont bien meilleures que la pisse de chat qu\'ils servent ici !",
	"Un commerçant est passé ce matin, il dit avoir vu des morts qui traînaient dans les collines voisines. Je n\'achèterai pas ces conneries, ça c\'est sûr !",
	"Il existe de nombreux endroits, perdus et oubliés depuis longtemps, qui recèlent de grandes richesses.",
	"Si vous visitez la taverne de %randomtown%, n\'oubliez pas de goûter leur chèvre rôtie, vous ne mangerez jamais aussi bien ailleurs !",
	"Les mercenaires ne sont pas très populaires par ici. Ils tuent, pillent et saccagent comme de vulgaires brigands, alors ne t\'attends pas à être accueilli avec des acclamations et des fleurs.",
	"Si vous avez besoin de provisions, allez voir le vieux %randomname% au marché de %townname%. Dites-lui que je vous envoie !",
	"Demain soir, le célèbre ménestrel %randomname% {l\'Oiseau chanteur | le Barde | le Conteur | le Rossignol | le Poète} vient dans cette même taverne, vous ne devez pas le manquer !",
	"Ne vous fiez pas aux potions du barbier ! Un ami de l\'oncle de l\'ami de mon cousin en a bu une et ça l\'a transformé en crapaud, je le jure !",
	"J\'ai entendu parler d\'une compagnie libre du nom de %randommercenarycompany% et il est dit qu\'ils collectent les oreilles de leurs ennemis et les portent autour du cou !",
	"Ne buvez pas l\'eau de %randomtown%, je vous le dis. Vous aurez la diarrhée en un rien de temps !",
	"Mon cousin %randomname% a quitté la ville avec une compagnie de mercenaires comme la vôtre, %randommercenarycompany% ou quelque chose comme ça. Je n\'ai plus de nouvelles de lui depuis...",
	"D\'un mercenaire à un autre : Si vous tenez à votre réputation de mercenaire, vous feriez mieux de ne pas trahir vos employeurs. Certains se donneront beaucoup de mal pour vous traquer, dire du mal de vous et vous faire payer.",
	"Les maisons nobles agissent comme un vieux couple ; querelles et disputes constantes. Et qui souffre le plus de ces querelles ? Pas les grands seigneurs dans les tours de leurs châteaux, non, c\'est nous, les gens simples, bien sûr !",
	"Je resterais loin des marécages et des marais. Il y a d\'horribles maladies qui n\'attendent que de vous attraper.",
	"J\'ai entendu dire qu\'il y avait un mage au conseil de %randomtown%, un vrai sorcier. Je ne suis pas sûr de le croire.",
	"J\'adore les femmes ! Leur apparence, leur façon de parler. Je ne sais pas ce que je ferais dans un monde sans elles...",
	"C\'est toi et ton %companyname% ! Tu te souviens de moi dans %randomtown% ? On a parlé de... enfin, je ne me souviens pas vraiment, mais on est là ! Buvons ! Comment allez-vous ?",
	"La mort fait partie de la vie. Plus tôt vous l\'accepterez, plus vous pourrez apprécier votre séjour dans ce monde.",
	"Une de mes dents est tombée l\'autre jour, tu vois ? Je pense que les autres sont si lâches qu\'elles sont sur le point de suivre. Tu le sens ? Vas-y, touche. Elles sont en vrac, non ?",
	"Mon Dieu, j\'ai besoin de pisser. Tu peux surveiller cette bière pour moi ?"
];
gt.Const.Strings.RumorsCivilian <- [
	"Soyez toujours sceptique envers la noblesse, mon ami. On ne sait jamais ce qu\'ils veulent vraiment.",
	"Vous avez déjà pensé à poser votre épée et à vous installer ? Les mercenaires ont tendance à avoir des vies plutôt courtes.",
	"Ils ont trouvé la ferme du vieux %randomname% brûlée l\'autre jour. Toute la famille était pendue à un chêne voisin...",
	"Depuis que des brigands ont brûlé la ferme de mon vieux père, j\'ai échangé la fourche contre la chope de bière. J\'espère qu\'ils auront ce qu\'ils méritent un jour.",
	"Notre milice est dans un état pitoyable, des piques rouillées et des boucliers vermoulus partout. J\'aimerais que le conseil prenne des couronnes en main et achète de vraies armes à ces pauvres gens.",
	"Nous n\'avons pas besoin de mercenaires comme vous ici ! Vous n\'apportez que des ennuis. Notre milice peut prendre soin de nous. Elle l\'a toujours fait et le fera toujours.",
	"La fille du meunier a disparu la nuit dernière. Ils l\'ont retrouvée et elle va bien, mais elle ne veut pas en parler.",
	"Farkin\' %randomname% et son chien farkin\'. Une bande de puces qui aboie jour et nuit, qu\'il pleuve ou qu\'il fasse soleil. Je n\'en peux plus, je n\'en peux vraiment plus...",
	"J\'ai entendu dire que certaines pierres tombales dans le vieux cimetière ont été renversées. Mais aucune personne saine d\'esprit n\'irait là-bas de toute façon.",
	"J\'ai acheté ce scramasax l\'autre jour à un marchand ambulant. Une vraie affaire, a-t-il dit. Un homme doit se protéger, lui et sa famille, tu vois.",
	"Je ne fais pas confiance à la milice ici. Une fois, alors qu\'une bande de hors-la-loi approchait, ils ont fait demi-tour et se sont enfuis dans les collines sans se battre !",
	"Il y a eu un meurtre ici. Un bâtard de %randomtown% a planté un couteau dans le dos d\'un des marchands. Il verra le noeud coulant dimanche, tu devrais venir voir !",
	"Ils ont brûlé %randomfemalename% sur le bûcher la semaine dernière, un chasseur de sorcières l\'a fait. Il est apparu un jour, l\'a accusé de sorcellerie et l\'a fait brûler. Le conseil n\'a pas protesté et l\'homme est parti peu après. J\'aimerais savoir qui c\'est, vraiment. Heureusement qu\'il nous a sauvés de cette sorcière, je suppose..."
];
gt.Const.Strings.RumorsMilitary <- [
	"Vous avez déjà combattu un orque ? On dit qu\'ils sont deux fois plus grands et trois fois plus forts qu\'un homme, et qu\'ils peuvent nous couper en deux d\'un seul coup !",
	"Ramasser des fermiers et des pêcheurs désespérés pour votre compagnie est très bien, mais vous devriez chercher des recrues dans un château comme celui-ci. Ici, tu trouveras des gens qui savent vraiment quel bout de l\'épée va où.",
	"Un bouclier solide est un vrai sauveur, laissez-moi vous le dire. Je ne voudrais pas qu\'un homme se batte sans.",
	"Le commandant de la garnison a combattu dans la Bataille des Noms. Il prétend que les gros orcs se débarrassent des coups de hache de guerre à la tête, lui oui. Je ne sais pas quoi en penser.",
	"Il y a des choses dehors bien plus effrayantes qu\'un groupe de brigands. Vous verrez ce que je veux dire bien assez tôt si vous allez au-delà des frontières.",
	"Je compte toujours sur ma hache pour briser le bouclier de l\'ennemi. Même le plus grand des hommes tombera rapidement lorsqu\'il ne pourra plus se défendre.",
	"Si j\'ai appris une chose durant mes années de soldat, c\'est que le terrain surélevé gagne les batailles. Faites-moi confiance sur ce point.",
	"J\'étais un mercenaire comme vous, mais j\'ai pris une flèche dans le genou.",
	"J\'ai vu %randomnoble% à un tournoi récemment. Bon sang, quel spectacle, cet homme. La façon dont il joute, je veux dire. Il a gagné le prix et toutes les femmes l\'ont aimé.",
	"Je suis vieux maintenant, mais je me souviens encore de ma première bataille. J\'ai pissé dans mon pantalon avant même que la première flèche ne soit tirée. Ha !",
	"Je suis allé à %randomtown% il n\'y a pas longtemps et ils m\'ont parlé de loups aussi grands qu\'un homme, avec des dents aussi longues que les doigts de ma main. Je n\'ai vraiment pas envie d\'en rencontrer un.",
	"Vous savez que les orcs fabriquent leurs armures avec ce qu\'ils dépouillent de ceux qui tombent contre eux ? Honnêtement, je n\'invente rien. Ils les portent comme des trophées ou quelque chose comme ça. Si tu rencontres un jour un de ces grands orcs, tu verras. Ils ont l\'air d\'avoir un ou deux chevaliers autour d\'eux.",
	"1ère Compagnie %townname%. Le meilleur groupe d\'imbéciles et de crapules avec lequel j\'ai jamais servi. Je ne les échangerais pour rien au monde.",
	"Ma femme et mes deux filles me manquent. Je suis stationné à %townname% depuis trop longtemps déjà, mais un homme doit bien mettre de la nourriture sur la table d\'une manière ou d\'une autre.",
	"Nous allons bientôt repartir pour patrouiller sur les routes. Parfois, j\'ai l\'impression que tout tomberait à l\'eau si nous n\'étions pas là pour maintenir l\'ordre.",
	"Putain de devoir de patrouille. Je suis à peine rentré, j\'ai encore des ampoules aux pieds à cause de la marche et on est sur le point de repartir. Mettez-nous juste sur des chevaux, je vous dis !",
	"J\'ai été gravement blessé il y a quelques mois lors d\'une escarmouche contre des gobelins. Je ne sentais plus mes jambes, mais les gars m\'ont porté jusqu\'à %townname%. Que Dieu les bénisse.",
	"Vous connaissez le territoire des peaux-vertes grâce aux idoles qu\'ils érigent à partir de crânes et d\'os. De crânes et d\'ossements humains.",
	"Quatorze. C\'est le nombre d\'hommes que j\'ai tués. Les femmes, je compte en plus, trois jusqu\'à présent. Et vous ?",
	"Je fais habituellement la surveillance sur le corps de garde. Pour être honnête, cracher sur des voyageurs est le seul plaisir que j\'ai de la journée.",
	"L\'ambiance au sein de la garnison est plutôt mauvaise. Ils disent que le paiement a été retardé plusieurs fois déjà et tout le monde commence à perdre patience.",
	"Quand j\'ai été transféré à %nom de la ville%, je n\'aurais jamais imaginé que la vie ici serait si terne et si dure. Mais c\'est toujours mieux que de travailler dans les champs jusqu\'à ce que ton dos se brise, je suppose...",
	"Je préfère me battre avec mon fléau. C\'est difficile de se défendre et peu importe s\'ils ont un bouclier, je le contourne et je réduis leur tête en bouillie !",
	"C\'est presque impossible de trouver un bouclier fiable par ici, ces satanés trucs se cassent en deux. J\'en garde un de rechange sur moi maintenant, juste au cas où. Je devrais faire payer plus cher les hommes qui se battent à la hache, ha !",
	"Un jour, je serai le porte-drapeau de la compagnie. Il n\'y a que les plus courageux d\'entre nous et ils sont dans la compagnie depuis des années et des années, vous savez, mais c\'est le plus grand honneur pour un homme de sang commun. J\'ai même vu un chevalier serrer la main des nôtres une fois.",
	"J\'ai entraîné la milice avant, et laissez-moi vous dire, les lances sont les meilleures armes quand les hommes ne savent pas encore ce qu\'ils font. Pas cher et facile à frapper. Rassemblez quelques hommes pour un mur de lances et il est difficile de s\'en approcher sans une lance dans le ventre.",
	"Vous avez déjà combattu des gobelins ? Ce sont d\'horribles petites bestioles, ne vous fiez pas à leur taille. Je prendrais de grands boucliers pour protéger les hommes de leurs flèches. Et une meute de chiens de garde pour les écraser quand ils se dispersent, si vous pouvez vous le permettre."
];
gt.Const.Strings.RumorsMiningSettlement <- [
	"L\'autre jour, ma pioche s\'est cassée pendant que je martelais. Un morceau m\'a touché la joue.Un peu plus je perdais un œil !",
	"Les mines sont un vrai piège mortel, on perd des hommes chaque semaine. Même s\'aventurer avec toi pourrait être meilleur pour la longévité, ha !",
	"Travailler dans les mines a aussi ses mérites, tu sais. On n\'est jamais mouillé par la pluie, c\'est juste la poussière qui finit par nous tuer.",
	"Dans l\'autre puits de mine, %randomname% a trouvé une pépite de la taille de mon poing ! Le contremaître l\'a eu avant qu\'il ne puisse la cacher."
];
gt.Const.Strings.RumorsFarmingSettlement <- [
	"Même avec la mauvaise récolte de cette année, le propriétaire ne nous laisse pas de répit ! Les gens de la haute ont droit à leurs festins, vous savez...",
	"Si vous cherchez à faire le plein de nourriture et de provisions, allez au marché et cherchez %randomname%. Il a la meilleure qualité et les prix les plus bas !",
	"J\'ai été ouvrier agricole toute ma vie et parfois j\'aurais aimé avoir la chance de travailler pour une compagnie comme la vôtre... Mais il est trop tard pour ça maintenant.",
	"Il y a beaucoup de jeunes et de naïfs qui cherchent l\'aventure. J\'espère que vous prendrez soin d\'eux et que vous les ramènerez un jour sains et saufs dans leurs familles."
];
gt.Const.Strings.RumorsFishingSettlement <- [
	"La mer est une maîtresse capricieuse. Un moment elle est aussi calme qu\'un miroir et le suivant vous vous retrouvez dans une tempête luttant pour votre vie.",
	"Personne ne sait ce qui vit dans les eaux noires profondes, mais on entend les vieux pêcheurs parler de poissons géants plus grands que n\'importe quel navire, de tentacules qui écrasent les bateaux comme s\'ils étaient des coquilles de noix, et d\'yeux morts et maléfiques sous la surface.",
	"Certains des vieux pêcheurs vous diront que les personnes perdues en mer sont maudites pour marcher sur les fonds marins, et qu\'elles ne sont libérées que si elles entraînent d\'autres personnes pour prendre leur place. Le prêtre dit que ce n\'est pas vrai, mais je ne sais pas. Pourquoi les anciens le disent-ils, alors ?",
	"Je place toujours le plus gros poisson de ma pêche devant la porte de %randomfemalename% pour la courtiser. Un jour, je vais me révéler comme son admirateur secret et lui demander sa main !"
];
gt.Const.Strings.RumorsForestSettlement <- [
	"J\'ai été bûcheron toute ma vie, comme mon père avant moi. Mais les jeunes d\'aujourd\'hui sont friands d\'aventure et de découverte du pays, tu pourrais bien en trouver au marché qui n\'auront aucun scrupule à t\'accompagner sur la route.",
	"Il y a des choses dans la forêt... dans les parties profondes et sombres, il y a des choses. Personne n\'ose en parler mais croyez-moi, ce ne sont pas des animaux...",
	"Dites, vous vous intéressez aux sculptures sur bois ? Les œuvres de %randomname% sont de véritables œuvres d\'art et ont fait connaître notre ville dans tout le royaume !",
	"Engager un homme des bois pourrait être une bonne idée pour un mercenaire comme vous, je dirais. Ils doivent savoir manier ces grandes haches !",
	"J\'ai entendu des gens parler d\'yeux qui les observent depuis le bord de la forêt. Il semblerait que de viles créatures fassent leur nid dans ces bois. Peut-être qu\'elles évaluent leur proie avant de frapper.",
	"D\'aussi loin que je me souvienne, les bois d\'ici sont pleins de vie sauvage. Des cerfs, des sangliers, des loups et des ours les parcourent en grand nombre. C\'est pourquoi il est de tradition que les familles enseignent l\'art du tir à l\'arc dès l\'enfance. Essayez de surpasser n\'importe lequel de nos gars avec un arc et vous êtes sûr d\'être déshonoré."
];
gt.Const.Strings.RumorsTundraSettlement <- [
	"Vous pouvez penser que notre terre est stérile et peu abondante, mais une fois que vous vivrez ici, vous apprendrez à l\'aimer comme aucune autre !",
	"Les clans et les familles dans ces régions sont encore forts et définissent qui nous sommes. Ces gens du Sud ne comprendront jamais comment les choses fonctionnent ici dans le Nord.",
	"Si vous cherchez à gagner de l\'argent rapidement avec quelques échanges, cherchez des fourrures. Celles d\'ici sont les meilleures de loin en loin.",
	"Tu es venu au bon endroit si tu cherches des hommes capables de renforcer ta compagnie. Nous, les gens du nord, sommes forts, robustes et honnêtes !"
];
gt.Const.Strings.RumorsSnowSettlement <- [
	"Le meilleur remède contre les vents mordants et le froid glacial se trouve ici : Bière et hydromel !",
	"Il y a 15 jours, %randomname% a disparu en rentrant de la taverne. On l\'a trouvé congelé le lendemain matin. J\'aurais pu le vendre à un noble comme statue, haha !",
	"On raconte que des silhouettes se déplacent dans les tempêtes de neige et que des hurlements surnaturels se mêlent aux vents... mais je ne voudrais pas vous troubler avec les contes du peuple.",
	"On m\'a dit qu\'il y a longtemps, ce pays était tout vert, avec de nombreux châteaux fiers et des tours impressionnantes. La plupart d\'entre eux ne sont plus que des ruines et sont recouverts de neige. Mais ils doivent bien être quelque part...",
	"Quatre hivers. Quatre hivers depuis que j\'ai vu une chance de gagner de l\'argent rapidement et que j\'ai pillé une chapelle en bord de route. J\'ai mis le fer dans le ventre d\'un saint homme qui a essayé de me retenir ; maintenant, aucune somme d\'argent ne peut rembourser la dette que mon esprit a contractée."
];
gt.Const.Strings.RumorsSteppeSettlement <- [
	"Vous devez transpirer comme des porcs sous toute cette armure. Peut-être devriez-vous voyager quand la lune est visible.",
	"Laissez-moi vous dire que le vin du sud est le meilleur que vous puissiez trouver dans toutes les terres. Mais tu ferais mieux de commencer à frapper quelques têtes ou d\'autres moyen pour pouvoir t\'offrir le bon vin, parce qu\'il n\'est pas bon marché.",
	"Un commerçant du nord s\'est perdu dans la steppe l\'autre semaine. Il est revenu mais n\'a pas cessé de fantasmer sur un lac qu\'il aurait découvert entouré de plantes luxuriantes et d\'animaux étranges.",
	"Dites à vos hommes de ne pas toucher à la fille de l\'aubergiste. Le dernier amoureux qui a tenté quelque chose a eu le nez coupé.",
	"Je suis originaire du nord, j\'ai déménagé à %nom de la ville% il y a quelques années. Je n\'ai jamais pu supporter le froid, la neige et le vent, jour après jour. Alors un jour, je me suis dit, %randomname%, j\'ai dit, va là où le soleil réchauffe la terre et où tu ne trembles pas à chaque fois que tu vas chercher du bois pour le feu. Et c\'est ce que j\'ai fait. Je ne l\'ai pas regretté depuis."
];
gt.Const.Strings.RumorsSwampSettlement <- [
	"Vous aimez les champignons ? Eh bien, je les déteste ! Mais il n\'y a pas grand chose d\'autre à trouver dans ce marécage puant à part des moucherons et des araignées.",
	"Les marchands ne viennent pas souvent ici. Leurs grands chariots ont tendance à s\'enliser dans la boue et devinez qui doit les aider quand ça arrive...",
	"Il y avait autrefois une route en pierre qui menait ici et qui amenait des commerçants, des clients et toutes sortes de gens. Un jour, elle s\'est complètement enfoncée dans le marais et regardez cet endroit maintenant...",
	"Ne vous promenez pas dans les marais la nuit ! Vous pourriez vous perdre, oui, mais dans le marais la nuit, il y a des choses bien pires qui peuvent arriver à un homme. Demandez à n\'importe qui par ici."
];
gt.Const.Strings.RumorsDesertSettlement <- [
	"Ces gens du nord paient bien pour notre soie et nos épices, alors on a des caravanes qui montent tout le temps. Et les caravanes ont besoin d\'escortes, vous savez.",
	"Si je peux te donner un conseil, c\'est celui-ci : ne t\'aventure pas trop loin dans le désert. Il y a des choses bien pires que la chaleur et le sable au bout du monde.",
	"Ces chiens du nord n\'ont aucun droit de venir sur nos terres, ils devraient rester à leur place !"
];
gt.Const.Strings.RumorsItemsOrcs <- [
	[
		"Une caravane transportant une arme de cérémonie précieuse a été attaquée à %direction% d\'ici. La rumeur dit que les victimes avaient tous les os brisés et qu\'une terrible puanteur flotte dans l\'air.",
		"Un client a récemment parlé d\'une arme appelée %item% qu\'il voulait vendre. Il a dit qu\'il a été effrayé par des bêtes à la peau verte sur le chemin de la ville et qu\'il l\'a abandonnée %terrain% %direction% d\'ici.",
		"Un voyageur m\'a dit l\'autre jour qu\'il avait vu de ses propres yeux le plus grand homme vivant brandissant ce qu\'il appelait %item%. Ça me semble être des foutaises, mais si ça vous intéresse, le type est parti d\'ici vers la %direction%."
	],
	[
		"Un grand aventurier avec un joli visage est venu ici il y a quelques nuits. Il se dirigeait dans la direction d\'ici pour tuer des peaux-vertes. Il portait un bouclier fantaisie sur le dos, on aurait dit un chevalier, mais il m\'a dit qu\'il ne l\'était pas.",
		"On dit qu\'un bouclier célèbre, j\'ai oublié comment il s\'appelait, a empêché un jour un rocher de dévaler une colline et d\'écraser un camp. Ça m\'a l\'air d\'être de la merde. Mais nous ne saurons jamais si c\'est vrai que c\'est un trophée de guerre orc maintenant, caché quelque part à %distance% dans la %direction% d\'ici.",
		"Ne me croyez pas sur parole, mais il paraît que des gros balourds verts à %direction% d\'ici se baladent avec un incroyable bouclier appelé simplement %item%. Je ne sais pas comment ils ont pu l\'obtenir.",
		"Le manoir d\'un noble a été attaqué par des peaux vertes il y a quelques jours. Ils se sont enfuis avec un bouclier ou une relique célèbre. Il paraît que ces salauds de peaux vertes se terrent quelque part à %direction% d\'ici."
	],
	[
		"Vous connaissez les orcs ? Des bêtes massives et fortes comme des bœufs ! Une bande de mercenaires qui se faisait appeler %randommercenarycompany% est passée et s\'est dirigée %direction% pour les traquer il y a quelques semaines. Ils ne sont jamais revenus, mais leur chef portait l\'armure la plus impressionnante que j\'ai jamais vue de ma vie !",
		"Oh, avez-vous entendu parler de %item% ? On dit qu\'il a été volé il y a des années lors de la dernière invasion orque. On l\'a aperçu dans la direction %d\'ici, mais moi, je ne connais pas les détails. Je ne voulais pas vous donner de faux espoirs.",
		"Un célèbre armurier a été tué il y a quelques jours. La rumeur dit que des orcs ont saccagé sa maison et se sont enfuis avec son chef-d\'œuvre dans une direction %direction% d\'ici. Peut-être que quelqu\'un d\'autre pourra vous en dire plus.",
		"La rumeur dit que %randomnoble% s\'est fait endormir pour toujours par une bande de peaux-vertes %direction% d\'ici. Il était connu pour abuser de tous ses serviteurs, donc vous ne trouverez personne qui le pleure par ici. C\'est juste dommage pour l\'armure de maître dont il se vantait, celle-là pouvait nous acheter beaucoup de cochons et de vaches. Et des poulets !"
	]
];
gt.Const.Strings.RumorsItemsGoblins <- [
	[
		"Un noble très énervé m\'a raconté l\'autre jour que des peaux vertes stupéfiantes s\'étaient emparées de son héritage familial après avoir empoisonné ses chiens de garde. Il jure qu\'ils ont caché %terrain% quelque part à %distance% d\'ici, mais je ne pense pas qu\'il ait jamais convaincu quelqu\'un de le récupérer pour lui. Certainement pas moi.",
		"Vous avez peur des peaux-vertes ? Des soldats bien amochés sont passés par ici l\'autre jour. Ils disaient qu\'ils voulaient arracher une arme bien connue des gobelins %direction% d\'ici, mais on dirait bien que ça ne s\'est pas passé comme prévu et qu\'ils ont dû se retirer. Je suppose que leur prix est toujours à prendre."
	],
	[
		"Un fermier du haut %direction% m\'a dit qu\'il avait vu de petites créatures sinistres sur ses terres, portant un grand bouclier brillant et faisant des bruits diaboliques. Il dit que c\'était des gobelins, mais je dis qu\'il s\'est fait avoir par des jeunes !",
		"Ils ont trouvé le meilleur fabricant de boucliers de toute la région mort avec une fléchette plantée dans son cou à %direction% d\'ici. Les gens ont dit avoir vu des petites créatures s\'enfuir avec la moitié de sa marchandise.",
		"Quelque part à %directionnel d\'ici, il y a des gobelins. La seule raison pour laquelle je le sais, c\'est que tous les connards qui viennent par ici racontent qu\'ils s\'en sont sortis de justesse. Il y en a même un qui dit avoir perdu son bouclier de maître en le piétinant."
	],
	[
		"La rumeur dit qu\'une pièce d\'armure hors de prix et de valeur a été volée au poste de garde par de petites créatures démoniaques qui l\'ont transportée dans la %direction%. %randomname% dit que ça devait être des gobelins, mais personne ici ne sait vraiment à quoi ils ressemblent.",
		"On dit que les kobolds et les gobelins s\'intéressent particulièrement à tout ce qui brille. Je n\'ai jamais cru moi-même que c\'était vrai, mais j\'ai vu à plusieurs reprises quelque chose qui scintillait au soleil %terrain% %direction% d\'ici et j\'ai entendu des histoires étranges sur des créatures courtes et trapues qui errent dans cette région.",
		"Vous serez peut-être intéressé d\'apprendre que notre vieil herboriste à l\'extérieur de la ville s\'est fait voler la nuit dernière juste au moment où un riche chevalier lui rendait visite. Les assaillants, il prétend qu\'il s\'agissait de petites créatures ressemblant à des enfants difformes, ont tué le chevalier et sont partis en %terrain% dans la %direction%."
	]
];
gt.Const.Strings.RumorsItemsBandits <- [
	[
		"La rumeur dit qu\'une bande de crapules à %direction% d\'ici a mis la main sur un objet sophistiqué et pointu lors d\'un casse audacieux.",
		"Une bande de voyous a essayé de faire un raid sur une caravane à %distance %d\'ici. Ils ont tous été tués, mais la rumeur dit qu\'une arme de valeur a disparu pendant le combat. Les gardes de la caravane la recherchent frénétiquement depuis.",
		"Un mécène ahuri m\'a dit qu\'il était retenu prisonnier par des voleurs à %terrain% %distance% d\'ici. Il a dit qu\'ils avaient quelque chose de vraiment joli avec eux. Une sorte d\'arme curieuse.",
		"Le capitaine de la garde a déserté il y a quelque temps pour rejoindre un camp de pillards caché à %terrain% dans la %direction%. Mon oncle, qui a servi sous ses ordres, prétend qu\'il a dévalisé l\'armurerie avant de partir et qu\'il a pris un objet de grande valeur."
	],
	[
		"Le capitaine de la garde a déserté il y a quelque temps pour rejoindre un camp de pillards caché %terrain% à la %direction%. Mon oncle, qui a servi sous ses ordres, prétend qu\'il a fait une descente à l\'armurerie avant de partir et qu\'il a trouvé un objet de grande valeur.",
		"J\'ai entendu dire que le fameux bouclier %item% a été aperçu. %randomname% prétend qu\'il appartient à une bande de pillards durs à cuire qui campent à %direction% d\'ici. Mais bon, %randomname% parle beaucoup de choses dont il ne sait rien.",
		"Tout ce dont les gens parlent par ici, ce sont de maudits pillards. Je suppose qu\'ils sont la coqueluche des rumeurs parce qu\'ils ont mis la main sur le %item% ou quelque chose comme ça maintenant. Où ça ? Oh, quelque part %terrain%."
	],
	[
		"L\'ami d\'un ami s\'est fait voler à %direction% d\'ici par un groupe de hors-la-loi l\'autre jour. Il prétend que le chef portait une armure des plus étonnantes !",
		"Le capitaine de la garde a déserté il y a quelque temps pour rejoindre un camp de pillards caché à %terrain% à %direction%. Mon oncle, qui a servi sous ses ordres, prétend qu\'il a dévalisé l\'armurerie avant de partir et qu\'il s\'est emparé d\'un objet de grande valeur.",
		"Un jeune homme effronté de la noblesse est passé l\'autre jour, je pense, à la recherche d\'un vieil héritage familial appelé %item%. La dernière fois que je l\'ai vu, il se dirigeait vers %direction% d\'ici."
	]
];
gt.Const.Strings.RumorsItemsUndead <- [
	[
		"Maintenant, je ne veux pas lancer de rumeurs, mais j\'ai vu un homme mort marcher à %direction% d\'ici. Ses mains pourries tenaient une arme extraordinaire mais je n\'oserai plus jamais y aller de ma vie !",
		"Un charognard ivre est venu la nuit dernière, il nous a dit qu\'il avait essayé d\'arracher une arme sertie de pierres précieuses des mains d\'un mort à %distance% dans la %direction%. Il a dit que sa prise était comme un étau, et qu\'il a fait un bruit, alors il s\'est enfui. C\'est n\'importe quoi, mais il avait l\'air effrayé comme jamais.",
		"Il y a beaucoup de rumeurs sur les morts qui reviennent sur terre. %randomname% dit qu\'il y en a dans la %direction% d\'ici. Ça me semble être des foutaises."
	],
	[
		"Il paraît qu\'un tas de tombes à %direction% d\'ici sont vides. Quelqu\'un a dit que des fossoyeurs cherchaient un célèbre bouclier enterré là. Bizarrement, personne n\'a vu ces fossoyeurs, alors c\'est peut-être des foutaises.",
		"Alors j\'ai regardé les livres de l\'intendant et je suis tombé sur de vieilles cartes qui décrivaient un ancien cimetière noble à %terrain% %distance% d\'ici. Cependant, personne n\'a encore été capable de le trouver. Eh bien, certaines choses ne sont pas faites pour être trouvées, je suppose."
	],
	[
		"Donc %terrain% %direction% d\'ici est supposé être le dernier lieu de repos d\'une pièce d\'armure mystique. Je ne connais pas le nom moi-même, je sais juste que beaucoup d\'aventuriers y vont et ne reviennent pas. Je ne sais pas pourquoi je vous en ai parlé, vraiment. J\'aime vos affaires.",
		"Vous avez entendu parler de %location% ? Demandez à n\'importe qui par ici, elle hante %nom de la ville% depuis avant ma naissance. Les gens disent qu\'une armure des dieux y est scellée à jamais, depuis l\'époque où l\'homme s\'est installé ici. "
	]
];
gt.Const.Strings.RumorsItemsBarbarians <- [
	[
		"Rien n\'est sacré pour ces brutes barbares ! Un prêtre complètement nu a trébuché ici depuis %direction%. Il était en route pour apporter une relique vénérée au temple mais ils la lui ont prise.",
		"Une compagnie de mercenaires est passée par ici pour chasser les barbares. Le chef brandissait une arme que je n\'avais jamais vue auparavant. Ils ont pris %direction% et on ne les a plus jamais revus.",
		"Lorsque vous vous dirigez vers %terrain% %direction%, gardez les yeux ouverts pour un groupe d\'hommes sauvages féroces. Ils pourraient vous mener à leur cachette où se trouverait une arme volée célèbre."
	],
	[
		"Hark ! Une tribu de barbares incultes a été vue %direction% d\'ici avec un bouclier appelé %item% dans leurs mains sales ! Tuez-les et récupérez-le !",
		"L\'ami d\'un ami a aperçu des hommes sauvages au loin à %direction% d\'ici. Il jure qu\'ils portaient un bouclier finement ouvragé. J\'appelle ça des conneries, car tout le monde sait qu\'ils n\'utilisent pas de boucliers comme nous !",
		"Seule une bonne défense permet une bonne attaque, disent-ils. Les rumeurs disent qu\'une bande de barbares à %distance% de la %direction% sont en possession d\'un bouclier réputé...",
		"Je faisais du commerce avec des barbares pas si sauvages que ça à %direction% d\'ici. La dernière fois que je leur ai rendu visite, un magnifique bouclier était accroché dans une de leurs huttes. Ils sont peut-être encore là %terrain%."
	],
	[
		"Vous semblez avoir besoin d\'une meilleure armure, mon ami. Si vous n\'avez pas peur d\'affronter des barbares féroces, il y a une très belle armure à réclamer dans un de leurs camps appelé %location%, %terrain% %direction% d\'ici.",
		"La fameuse %item% a été gardée dans l\'armurerie pendant des décennies, mais lorsque les hommes sauvages du nord sont arrivés, ils ont tout emporté avec eux. On dit qu\'ils campent quelque part à %terrain% %distance% d\'ici.",
		"Je suis venu ici pour récupérer un objet d\'héritage de mon défunt grand-père, juste pour apprendre qu\'il a été volé par des barbares en maraude. On dit qu\'ils rôdent quelque part à %terrain% %direction% d\'ici, mais je crains de ne jamais le récupérer.",
		"Êtes-vous aussi ici pour chercher %item% comme tous ces autres idiots ? On dit qu\'il se trouve quelque part dans %terrain% %direction%. Rien que des foutaises si vous voulez mon avis..."
	]
];
gt.Const.Strings.RumorsItemsNomads <- [
	[
		"Les nomades prennent ce qu\'ils veulent et se cachent dans le désert. Les gardes les ont cherchés à %terrain% %direction% d\'ici. Je pense qu\'ils sont à %distance%.",
		"Les jours ici dans le sud sont aussi clairs que les nuits sont sombres. J\'ai dû trébucher et perdre ma précieuse arme %distance% à la %direction%, mais j\'ai renoncé à la chercher.",
		"Les artisans des temps anciens savaient vraiment comment fabriquer des armes remarquables. Les rumeurs disent qu\'une telle arme se trouve chez une tribu nomade qui se cache dans la %direction%, mais qui pourrait la leur prendre, moi ? Ha !"
	],
	[
		"Un bouclier reflétant la lumière du soleil comme un miroir, plus aveuglant que le midi dans le désert ! Où ai-je vu ça ? Des Nomades l\'avaient dans la %direction% %distance% d\'ici, si je me souviens bien.",
		"Toute ma vie, j\'ai chassé des nomades à travers les frontières %terrain%, mais je n\'en ai jamais vu un brandir un bouclier comme celui-ci. C\'était à %distance% de la %direction% d\'un de leurs camps.",
		"Les nomades ne prennent pas seulement aux vivants mais aussi aux morts ! On dit qu\'ils ont pillé le soi-disant %item% d\'une tombe à %direction% d\'ici où ils ont encore leur camp. Ils n\'ont vraiment aucune décence."
	],
	[
		"J\'étais le premier quartier-maître d\'un vizir. Quand la fameuse armure que j\'avais commandée pour un invité d\'honneur n\'est pas arrivée, j\'ai perdu mon poste. La caravane qui la transportait a été prise en embuscade par des nomades, j\'ai appris plus tard, à %direction% d\'ici.",
		"On dit qu\'une armure opulente est cachée à %terrain% %direction% d\'ici. De nombreux chercheurs de trésors n\'ont pas réussi à la récupérer, mais vous avez peut-être plus de chance ?",
		"L\'armurier le plus compétent du coin, qui se trouve être un de mes amis, s\'est fait piéger par ces maudits nomades et ils se sont enfuis avec une de ses armures hors de prix. Si vous croisez des nomades à %direction% d\'ici, fouillez leurs corps minutieusement !"
	]
];
gt.Const.Strings.RumorsGreaterEvil <- [
	[],
	[
		"Les nobles se disputent à nouveau comme deux vieilles sorcières à la clôture du jardin. Ils n\'arrivent pas à surmonter leur orgueil !",
		"Les nobles prendront toutes vos couronnes, vos fils et vos maris aussi, et les brûleront dans leurs luttes inutiles - mille malédictions sur eux !",
		"J\'ai fait mon temps dans l\'armée il y a vingt ans. J\'ai perdu une oreille, tu vois ? Maintenant mon garçon est en marche. Il a été arraché des écuries et forcé à aller au front. Guerre différente, même vieille merde. Je prie pour qu\'il reste baissé et garde son bouclier levé."
	],
	[
		"La marée verte continue de balayer les armées les unes après les autres ! Nous sommes tous condamnés ! Condamnés !",
		"Tous fuient les peaux vertes mais pas moi ! Je vais tenir bon, massue dans une main, javeline dans l\'autre ! Envoyez-les vers moi !",
		"Nous avons à peine combattu les peaux vertes la dernière fois à la Bataille des Noms, nous avons tout juste réussi, et maintenant ils sont de retour.",
		"Nous entendons des histoires de plus en plus de fermes et de hameaux brûlés chaque jour. Ce sont les peaux vertes qui font des raids dans la campagne."
	],
	[
		"Que les vieux dieux nous aident ! Les morts s\'agitent dans leurs tombes sur toutes les terres. Ils viendront et réclameront les vivants. Repentez-vous, repentez-vous et priez !",
		"Les nobles sont sur la défensive, et personne ne sait comment arrêter la menace des morts-vivants qui viennent pour nous. Je dois garder mon esprit ailleurs - aubergiste ! Un autre !",
		"Je devrais peut-être me pendre, en finir et rejoindre les rangs des morts-vivants. Cette attente me rend fou !",
		"Un homme a été trouvé mort sur la route. Il était assis bien droit sur une charrette à âne, tout desséché, comme une marionnette de peau, de vrilles et d\'os. L\'âne aussi. C\'est comme si le sang avait été aspiré hors d\'eux.",
		"Fantômes hideux, tombes vides, esclaves sans esprit d\'un autre monde ! Prends un verre, trouve une femme avant que tes dents ne se serrent ! Boie et mange, ne reste pas au sec, trois jours avant de mourir !",
		"%randomnoble% a vu son déjeuner revenir d\'entre les morts. Il était sur le point de prendre une bonne bouchée d\'oie farcie quand la chose a sauté de son assiette et s\'est mise à voler en rond. Ça a pulvérisé des pommes cuites à travers les quartiers d\'habitation. Ça a dû être un spectacle inoubliable."
	],
	[
		"Vous avez entendu les nouvelles ? Les armées se rassemblent à %randomtown% pour marcher vers le sud. J\'espère juste que les dorés ne riposteront pas un jour...",
		"Si vous cherchez de l\'argent, vous devriez aller vers le sud et donner une leçon à ces adorateurs du soleil !",
		"Quoi.... QUOI ! ? Je ne t\'ai pas entendu ! Je me battais contre ces disciples de Gilder à l\'Oracle et quelque chose de fort est passé près de mon oreille...",
		"Tu veux de la soupe ? J\'ai du boeuf et des pommes de terre là-dedans. Pas d\'épices, par contre. Je suis à court d\'épices à cause de la guerre.",
		"Le prêtre dit que les anciens dieux vous accueilleront si vous ne revenez pas de la croisade. C\'est une bonne chose à savoir, non ? Ces fanatiques de Gilder sont dangereux.",
		"Tu peux le croire ? %randomnoble% a payé des nomades pour guider son hôte dans le désert. C\'est de la folie, si c\'est vrai. Je ne ferais pas confiance à ces serpents pour autant que je puisse pisser.",
		"Un de mes neveux a été tué dans le désert. Pauvre garçon. Il a voulu protéger la foi et a été transpercé par une lance pour ça. Le bâtard qui a fait ça est toujours en vie. Faisons les payer pour ça, je dis. Faites-les payer, ces trois fois maudits !"
	]
];

