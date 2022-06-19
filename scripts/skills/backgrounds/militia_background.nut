this.militia_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.militia";
		this.m.Name = "Milicien";
		this.m.Icon = "ui/backgrounds/background_35.png";
		this.m.BackgroundDescription = "Toute personne ayant fait partie de la milice aura reçu au moins une formation de base en matière de combat.";
		this.m.GoodEnding = "Un ancien milicien comme %name% a fini par quitter la compagnie %companyname%. Il a parcouru les terres, visitant les villages et les aidant à établir des milices fiables avec lesquelles ils pouvaient se défendre. Ayant réussi dans un monde de plus en plus dangereux, %name% est finalement devenu un nom connu, appelé comme une sorte de \"réparateur\" pour venir s\'assurer que ces villages restent sûrs. Aux dernières nouvelles, il a acheté une parcelle de terrain et a fondé une famille loin des conflits de ce monde.";
		this.m.BadEnding = "%name% a quitté la compagnie qui s\'effondrait et est retourné dans son village. De retour dans la milice, il n\'a pas fallu longtemps pour que {les peaux vertes | les prédateurs} attaquent et qu\'il soit appelé au combat. On dit qu\'il s\'est tenu debout, ralliant la défense alors qu\'il tuait d\'innombrables ennemis avant de succomber à des blessures mortelles. Lorsque vous avez visité le village, vous avez trouvé des enfants jouant à se battre sous une statue faite à l\'image du milicien.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 10;
		this.m.Excluded = [
			"trait.hate_undead",
			"trait.clubfooted",
			"trait.fat",
			"trait.insecure",
			"trait.dastard",
			"trait.craven",
			"trait.asthmatic"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.Level = this.Math.rand(1, 2);
		this.m.IsCombatBackground = true;
		this.m.IsLowborn = true;
	}

	function onBuildDescription()
	{
		return "{Un milicien comme %name% n\'est mobilisé qu\'en cas de besoin. | Fauché et sans travail, %name% a rejoint la milice locale. | Pris à voler une pomme, %name% a été enrôlé dans la milice en guise de punition. | Bien que membre de la paysannerie, %name% était toujours prêt à s\'engager dans la milice et à protéger sa propriété. | La guerre est une bête affamée - les conscrits de la milice comme %name% sont ce qui la nourrit.} {Bien qu\'il ait reçu un bon entraînement, il y avait rarement assez de nourriture pour les soldats de \"seconde zone\". | Bien qu\'il se soit battu aussi fort que les professionnels, il n\'a pas réussi à obtenir le moindre respect pour son travail. | Étant le dernier échelon de la hiérarchie militaire, il a vite compris que cela signifiait que sa vie était sacrifiable. | Ses armes étaient rouillées et l\'armure inexistante. Malheureusement, les ennemis n\'étaient pas aussi bien équipés.} {Après une année passée à se balader avec du matériel de mauvaise qualité, il a décidé de chercher quelque chose d\'un peu plus à son goût : le mercenariat. | Quand un seigneur a envoyé toute sa milice vers une mort presque certaine, %name% a compris qu\'il devait chercher quelque chose de mieux s\'il voulait vivre. Il a apporté ses modestes compétences dans le domaine du mercenariat. | Les années passées dans un uniforme dans lequel il ne pouvait pas compter sur ses camarades ont poussé %name% à trouver quelque chose de mieux. Ce n\'est pas le meilleur soldat que vous ayez jamais vu, mais il est sérieux. | Lorsque sa milice a été dissoute, il est rentré chez lui et a découvert que sa ville avait été entièrement brûlée. Avec un pied déjà dedans, il était logique de rejoindre l\'un des nombreux groupes de mercenaires qui parcourent le pays. | La sobre tenue militaire de %name% cache un homme qui a connu sa part d\'entraînement et de combat.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				3,
				5
			],
			Stamina = [
				3,
				5
			],
			MeleeSkill = [
				5,
				5
			],
			RangedSkill = [
				6,
				5
			],
			MeleeDefense = [
				2,
				2
			],
			RangedDefense = [
				2,
				2
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

		if (this.Math.rand(0, 4) == 4)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.MilitiaTitles[this.Math.rand(0, this.Const.Strings.MilitiaTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		local weapons = [
			"weapons/hooked_blade",
			"weapons/bludgeon",
			"weapons/hand_axe",
			"weapons/militia_spear",
			"weapons/shortsword"
		];

		if (this.Const.DLC.Wildmen)
		{
			weapons.extend([
				"weapons/warfork"
			]);
		}

		items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));

		if (items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null && this.Math.rand(1, 100) <= 50)
		{
			items.equip(this.new("scripts/items/shields/buckler_shield"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_lamellar"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 6);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/full_leather_cap"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});

