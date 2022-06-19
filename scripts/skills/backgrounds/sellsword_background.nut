this.sellsword_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.sellsword";
		this.m.Name = "Mercenaire";
		this.m.Icon = "ui/backgrounds/background_10.png";
		this.m.BackgroundDescription = "Les mercenaires sont chères, mais une vie de guerre les a forgés en combattants expérimentés.";
		this.m.GoodEnding = "%name% le mercenaire a quitté la compagnie %companyname% et a créé sa propre entreprise de mercenaires. D\'après ce que vous savez, c\'est une entreprise très prospère et il se lie souvent avec les hommes de la compagnie %companyname% pour travailler ensemble.";
		this.m.BadEnding = "%name% a quitté la compagnie %companyname% et a créé sa propre entreprise concurrente. Les deux compagnies se sont affrontées dans des camps opposés lors d\'une bataille entre nobles. Le mercenaire est mort lorsqu\'un membre de la compagnie %companyname% lui a enfoncé la tête dans le casque d\'un chevalier errant.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.weasel",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
			"trait.irrational",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 4);
		this.m.IsCombatBackground = true;
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
		return "{%fullname% a travaillé comme mercenaire depuis que son père lui a transmis son équipement. | %fullname% ne se souvient pas d\'une époque où il n\'était pas un épéiste hors-pair. | En tant que mercenaire, %fullname% n\'a jamais eu à chercher longtemps du travail. | Les lettrés parlent de lâcher les chiens de guerre. %fullname% est l\'un de ces chiens. | Dans la guerre, il y a la mort et le profit. %fullname% cause la première pour gagner le second. | Il n\'y a jamais eu de meilleur moment pour les mercenaires comme %name% pour gagner une couronne ou deux. | Après que sa femme se soit enfuie avec ses enfants, un %name% en colère s\'est construit une carrière stable en tant que méchant mercenaire. | Il y a dix ans, %name% a tout perdu dans un incendie. Depuis, il travaille comme mercenaire. | %name% a toujours eu le goût de la violence et a poursuivi une longue carrière de mercenaire. | Autrefois pauvre, %name% a gagné une belle somme au fil des ans en tant que mercenaire. | %fullname% préfère garder pour lui d\'où il vient, mais sa réputation d\'épéiste hors-pair parle d\'elle-même.} {Bien expérimenté, il a voyagé en compagnie de nombreuses formations à son époque. | Les campagnes militaires ne sont que des encoches à sa ceinture. | Qu\'il s\'agisse de travailler comme garde du corps d\'un seigneur ou d\'être l\'homme de main d\'un marchand malhonnête, %name% a tout vu. | Il a autrefois gagné sa vie en tuant les bêtes sauvages qui envahissaient les habitations humaines. | Avec une sinistre rictus , il se vante d\'avoir tué toutes sortes de créatures vivantes. | À force d\'utilisation, le mercenaire a appris une chose ou deux sur des armes dont vous ne soupçonniez même pas l\'existence. | Le mercenaire compte le nombre de personnes qu\'il a tuées à ce jour et il semble ne pas vouloir s\'arrêter de sitôt. | Une épée et un bouclier à la main, le mercenaire semble faire ce qu\'il fait de mieux pour gagner sa vie.} {L\'homme n\'est pas étranger aux champs de bataille. | L\'homme n\'est pas étranger aux cruautés de la guerre. | Il est habitué aux dures réalités de la vie de mercenaire. | On dit de lui qu\'il est un rouage fiable dans n\'importe quel mur de boucliers. | Certains disent qu\'il peut tenir une position de combat aussi bien qu\'un chêne. | Les rumeurs courent que l\'homme aime la vue du sang. | Sans honte, il prend un malin plaisir à voir la souffrance des autres sur le champ de bataille. | Étrangement, il se joint rarement aux autres autour du feu de camp, préférant rester seul. | L\'homme aime raconter une bonne histoire sur la façon dont il a tué telle ou telle chose. | Lorsqu\'il en a l\'occasion, l\'homme est prompt à montrer une grande variété de styles de combat.} {Tant que vous avez le sou, %name% est à votre disposition. | Un vrai mercenaire, %name% combattra n\'importe qui du moment que la paye est bonne. | Faisant preuve d\'une belle maîtrise de l\'épée, %name% dit qu\'il peut transpercer n\'importe quel homme. | Avec un léger hochement de tête, %name% accepte de vous rejoindre si vous avez les couronnes. | Excité par l\'opportunité de gagner de l\'argent, %name% frappe sa tasse sur la table.}";
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 25)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 30)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
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
				5
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				13,
				10
			],
			RangedSkill = [
				12,
				10
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
				0,
				0
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.SellswordTitles[this.Math.rand(0, this.Const.Strings.SellswordTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 9);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/falchion"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/flail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/greataxe"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/longsword"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/weapons/billhook"));
		}
		else if (r == 6)
		{
			items.equip(this.new("scripts/items/weapons/winged_mace"));
		}
		else if (r == 7)
		{
			items.equip(this.new("scripts/items/weapons/warhammer"));
		}
		else if (r == 8)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}
		else if (r == 9)
		{
			items.equip(this.new("scripts/items/weapons/crossbow"));
			items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		}

		r = this.Math.rand(0, 5);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/leather_lamellar"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/mail_shirt"));
		}

		r = this.Math.rand(0, 9);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/padded_nasal_helmet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/closed_mail_coif"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/reinforced_mail_coif"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/kettle_hat"));
		}
		else if (r == 6)
		{
			items.equip(this.new("scripts/items/helmets/padded_kettle_hat"));
		}
		else if (r == 7)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});

