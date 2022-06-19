this.poacher_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.poacher";
		this.m.Name = "Braconnier";
		this.m.Icon = "ui/backgrounds/background_21.png";
		this.m.BackgroundDescription = "Les braconniers ont généralement des compétences dans l\'utilisation de l\'arc et des flèches pour chasser les lapins et autres animaux similaires.";
		this.m.GoodEnding = "%name%, ancien braconnier, a fini par économiser assez d\'argent pour quitter la compagnie %companyname%. Vous avez appris qu\'il a acheté un bout de terrain dans la montagne et qu\'il le travaille pour un noble local. Ironiquement, son travail consiste à chasser les braconniers.";
		this.m.BadEnding = "Ne voyant plus l\'intérêt de risquer sa vie pour si peu de couronnes, %name% l\'ancien braconnier a mis fin à la vie de mercenaire et est retourné chasser illégalement le cerf dans les bois. Un noble vous a un jour offert une grosse sacoche de couronnes pour le traquer spécifiquement. Vous avez décliné l\'offre, mais l\'écriture était sur le mur : ses jours sont comptés.";
		this.m.HiringCost = 65;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.hate_undead",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.loyal",
			"trait.fat",
			"trait.fearless",
			"trait.brave",
			"trait.bright"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
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
		return "{Attiré par le frisson de la chasse, | Cherchant à subvenir aux besoins de sa famille, | Avec un estomac qui gronde, | Après un hiver long et dur qui l\'a laissé sans réserve de nourriture,} %name% {part dans les bois à la recherche de chevreuils | a cherché une vie sauvage à laquelle, si l\'on se fie à sa nervosité, il n\'avait pas forcément droit | Grâce à toute sorte de bestioles qu\'on peut trouver dans les bois, il mangeait à sa faim, un arc bien attaché à ses épaules indiquant le moyen de se procurer ses repas | part dans les bois pour chasser le gibier avec un arc et une lance}. Originaire de %townname%, %name% {était, en tant que braconnier, le chasseur et le chassé | avait besoin de nourrir sa femme et ses enfants à la maison | cherchait à subvenir à ses besoins, à ceux de sa propre peau et à ceux de son estomac toujours plus gros | braconnait, c\'était un acte de rébellion contre l\'ordre des choses autant qu\'un moyen de remplir son ventre}. {Craignant que ses activités n\'attirent les chasseurs de primes ou les hommes de loi, il a décidé de faire sa vie en tant qu\'archer à \"louer\". | Fatigué de travailler si dur juste pour mettre de la nourriture sur la table, acheter un repas avec le salaire d\'un mercenaire semblait tellement plus facile dans son esprit. | Après une mauvaise chasse qui l\'a conduit à un long séjour dans le donjon d\'un seigneur, il préfère mettre sa tête en jeu en tant que mercenaire plutôt que d\'être pris au piège en tant que braconnier. | Des années de chasse solitaire ont usé l\'homme. Bien que la vie de mercenaire soit extrêmement dangereuse, il préfère mourir accompagné que seul. | Sa femme a longtemps plaidé pour qu\'il change ses habitudes de peur que toute la famille ne paie pour ses crimes. Il se tient ici maintenant, un témoignage de qui a gagné la dispute.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-5,
				5
			],
			Stamina = [
				3,
				0
			],
			MeleeSkill = [
				2,
				0
			],
			RangedSkill = [
				15,
				7
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				0,
				4
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Wildmen)
		{
			r = this.Math.rand(1, 100);

			if (r <= 50)
			{
				items.equip(this.new("scripts/items/weapons/short_bow"));
				items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
			}
			else if (r <= 80)
			{
				items.equip(this.new("scripts/items/weapons/staff_sling"));
			}
			else
			{
				items.equip(this.new("scripts/items/weapons/wonky_bow"));
				items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
			}
		}
		else
		{
			if (this.Math.rand(1, 100) <= 75)
			{
				items.equip(this.new("scripts/items/weapons/short_bow"));
			}
			else
			{
				items.equip(this.new("scripts/items/weapons/wonky_bow"));
			}

			items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.addToBag(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.addToBag(this.new("scripts/items/weapons/militia_spear"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});

