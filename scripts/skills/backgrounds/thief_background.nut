this.thief_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.thief";
		this.m.Name = "Voleur";
		this.m.Icon = "ui/backgrounds/background_11.png";
		this.m.BackgroundDescription = "Un bon voleur aura d\'excellents réflexes et la capacité d\'échapper à ses ravisseurs.";
		this.m.GoodEnding = "%name% le voleur s\'est retiré du mercenariat et a disparu de la circulation. Vous n\'en avez plus entendu parler depuis, mais il y a des rumeurs selon lesquelles un certain noble a vu l\'une de ses chambres fortes complètement vidée lors d\'un hold-up parfaitement exécuté.";
		this.m.BadEnding = "%name% le voleur a lu les lignes qui se dessinaient dans le sable et s\'est retiré de la compagnie %companyname% tant qu\'il le pouvait encore. Il a pris l\'argent qu\'il avait gagné et a monté une équipe de voleurs et de brigands. Aux dernières nouvelles, il a réussi un hold-up parfait, mais un de ses partenaires l\'a poignardé dans le dos et est parti avec toute la marchandise.";
		this.m.HiringCost = 95;
		this.m.DailyCost = 10;
		this.m.Excluded = [
			"trait.huge",
			"trait.teamplayer",
			"trait.hate_undead",
			"trait.hate_greenskins",
			"trait.hate_beasts",
			"trait.paranoid",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.brute",
			"trait.dumb",
			"trait.loyal",
			"trait.clumsy",
			"trait.fat",
			"trait.strong",
			"trait.hesitant",
			"trait.insecure",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.brute",
			"trait.strong",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"the Shadow",
			"the Cutpurse",
			"the Snake",
			"the Raven",
			"the Burglar",
			"the Snatcher",
			"the Black Cat",
			"the Prince",
			"Quickfingers",
			"the Thief"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}

	function onBuildDescription()
	{
		return "{Élevé par des voleurs de lait, de miel et d\'or, %name% est parti du mauvais pied. | Élevé par un père ivrogne et une mère malade, %name% a dû voler dès son plus jeune âge. | Étant le sixième enfant d\'une famille pauvre, le voleur en herbe %name% a d\'abord appris le métier en volant les restes du dîner. | Ayant grandi dans une famille au service d\'un riche noble, le futur voleur %name% a passé de nombreuses années à contempler l\'opulence royale - et à la voler. | Pris en charge par un orphelinat local, %name% n\'a pas tardé à se faire maltraiter par ses congénères. Il s\'est rabattu sur le vol pour survivre. | Orphelin, %name% a grandi dans la rue, ses journées étant rythmées par les sacs à main et les poches. | Bien qu\'il n\'ait jamais eu particulièrement besoin d\'argent, la jalousie de %name% pour les biens matériels l\'a conduit au vol. | Le gaspillage que faisaient les riches devant les pauvres a toujours déplu à %name%.  Alors il s\'est mis à voler les deux côtés, juste pour lui, juste pour en avoir encore plus. | Le père de %name% lui a appris tout ce qu\'il y avait à savoir sur le vol, y compris, malheureusement, comment poignarder dans le dos. | L\'église vole avec un plateau d\'argent. Les seigneurs le font avec le percepteur. Alors %name% s\'est dit pourquoi il ne peut pas le faire de ses propres mains ? | De plus en plus pauvre en grandissant, %name% a commencé à voler du pain. Bien nourri, il s\'est vite mis à voler des couronnes.} {Après des années de vols couronnés de succès, une erreur a fait atterrir %name% dans un cachot. Heureusement, des années de vol signifient aussi des années de crochetage de serrures et il n\'y a pas passé longtemps. | Mais lorsqu\'il a été pris en train d\'essayer de voler le calice d\'un temple, une rencontre avec un prêtre a convaincu %name% de prendre une autre voie. | Malheureusement, lors d\'un cambriolae violent dans un magasin local, %name% a été pris en flagrant délit. Des avis de recherche étaient placardés partout, ce qui rendait son travail difficile. | En osant couper la lanière d\'une bourse portée par riche commerçant, %name% se retrouva bientôt à soigner une main dépourvue de quelques doigts. Il aimait beaucoup ces doigts, aussi. | Grâce à son talent, %name% a été placé à la tête d\'une guilde entière. Mais après avoir subi une douzaine de tentatives d\'assassinat ratées, le voleur a réalisé qu\'il n\'y avait personne de confiance dans son métier. | En s\'associant avec une belle femme, %name% a réussi à voler tout le monde. Dommage que la femme l\'ait volé, à la fin. | En essayant de vendre quelques marchandises, un receleur de confiance s\'est avéré être un informateur. Une mauvaise expérience au pilori plus tard, le voleur était banni de %randomtown%. | C\'était le hold-up parfait. C\'est tout ce qu\'on peut dire à ce sujet. Maintenant, %name% a juste besoin de faire profil bas. | Torturé par un gang rival, il en est venu à perdre un certain nombre de dents, d\'ongles, et toute envie de reprendre le métier de voleur. | Son temps en tant que voleur a pris fin lorsque, arrêté, il a passé cinq jours au pilori pendant la saison des tomates. | Naturellement, il n\'a pas tardé à aller en prison. Il ne parle pas de son séjour là-bas, mais il est évident qu\'il souhaite ne jamais y retourner. | Mais un jour, il a appris qu\'il y avait de bien meilleures façons de faire tourner une lame pour une pièce de monnaie que le vol à la tire. | Mais son demi-frère a été capturé par un gang local, obligeant le voleur à trouver de nouveaux moyens de payer la grosse rançon. | Mais la vie de brigand n\'est pas facile. Arrêté pour avoir mangé un poulet qui n\'était pas le sien, l\'homme a perdu deux doigts et toute volonté de continuer à voler. | Après un hold-up qui a mal tourné, l\'homme a dénoncé tous ses anciens partenaires pour sauver sa peau. Maintenant, il ne peut plus jamais revenir au vol.} {Pour ce que vous en savez, %name% utilise juste les mercenaires comme camouflage. Quelles que soient ses raisons, il devra quand même mériter son salaire. | Vous reconnaissez %name% sur certaines affiches. Un homme qui est allé si loin sans se faire prendre doit avoir une certaine valeur. | D\'une main, %name% fait tourner une lame entre ses doigts. Avec l\'autre, il attrape votre sac à main. Impressionnant. Maintenant rendez-le moi. | Des années de vol ont rendu %name% habile à échapper aux problèmes. | %name% a les compétences pour être un bon mercenaire, assurez-vous simplement de faire attention à votre bourse en sa présence. | Vous ne pouvez pas faire confiance à un homme comme %name%, mais cet particularité est assez commune de toute façon. | On dit qu\'un jour, quelqu\'un a tiré une flèche sur %name%. Elle a raté, mais le voleur a gardé les plumes. | Il vaudrait mieux que l\'effort de %name% pour rejoindre les mercenaires ne soit pas un plan pour voler dans vos coffres. | Les avis de recherche disent que %name% est considéré comme \"armé et dangereux\". Parfait. | Il y a plein d\'hommes de loi qui cherchent %name%. Vous pouvez peut-être les convaincre de vous rejoindre aussi.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				5,
				0
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				5,
				8
			],
			RangedDefense = [
				5,
				8
			],
			Initiative = [
				12,
				10
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/headscarf"));
		}
	}

});

