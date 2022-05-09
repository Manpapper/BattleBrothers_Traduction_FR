this.disowned_noble_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.disowned_noble";
		this.m.Name = "Noble Déshérité";
		this.m.Icon = "ui/backgrounds/background_08.png";
		this.m.BackgroundDescription = "Les nobles déshérités ont souvent bénéficié d\'un entraînement au combat au corps à corps à la cour.";
		this.m.GoodEnding = "A noble at heart, the disowned nobleman %name% returned to his family. Word has it he kicked in the doors and demanded a royal seat. An usurper challenged him in combat and, well, %name% learned a lot in his days with the %companyname% and he now sits on a very, very comfortable throne.";
		this.m.BadEnding = "A man of nobility at heart, %name% the disowned noble returned to his family home. Word has it an usurper arrested him at the gates. His head currently rests on a pike with crows for a crown.";
		this.m.HiringCost = 135;
		this.m.DailyCost = 17;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.clumsy",
			"trait.fragile",
			"trait.spartan",
			"trait.clubfooted"
		];
		this.m.Titles = [
			"the Disowned",
			"the Exiled",
			"the Disgraced"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Thick;
		this.m.Level = this.Math.rand(1, 3);
		this.m.IsCombatBackground = true;
		this.m.IsNoble = true;
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
		return "{Une déception constante pour un père délirant | Une victime d\'une intrigue impliquant du poison et des gâteaux | Après avoir ouvertement dénoncé son propre héritage | Après qu\'une relation incestueuse avec sa sœur ait été révélée | Après l\'échec d\'un coup d\'État pour éliminer son frère aîné | Après que sa fierté et son orgueil l\'a conduit à mener l\'armée de son père à la défaite totale | Pour avoir accidentellement tué son frère aîné et héritier du trône lors d\'une chasse | Comme prix à payer pour avoir mal choisi ses alliés dans une guerre de succession | Pour avoir tenté de vendre des braconniers capturés comme esclaves | Attrapé en train de coucher avec un autre noble | Découvert à la tête d\'un complot de vol d\'enfants qui a choqué la paysannerie | Pour avoir tourné le dos aux dieux et provoqué une émeute parmi les croyants | Vu avec le livre de Davkul sous le bras}, %name% {a été désavoué et chassé de la propriété de sa famille, pour ne jamais revenir. | a été dépouillé de ses titres et exilé du pays. | a été expulsé par la force de ses terres et on lui a dit de ne jamais revenir. | a compris, sous la menace de la hache d\'un bourreau, qu\'il n\'avait plus sa place à la cour. | a vu la crode du bourreau, et ce n\'est que par un habile stratagème qu\'il y a échappé. | a été marqué du symbole de la honte et chassé de ses terres. | a été considéré comme ayant été impliqué dans une conspiration de trop et a été écarté des terres. | était considéré comme trop ambitieux, un trait dangereux parmi la noblesse.} {%name% cherche maintenant à se racheter et à être à la hauteur du nom de la famille. Un peu égoïste pour une équipe de mercenaires, mais noble quand même. | Sa posture affaissée par le scandale, la résistance aux difficultés de %name% a diminué. | Il est peut-être un combattant habile, mais %name% parle rarement de quelqu\'un d\'autre que lui-même. | Bien que rapide à l\'épée, on a l\'impression que quelqu\'un comme %name% a été renié pour une raison. | Sans chance et pratiquement sans argent, %name% s\'aventure dans le domaine des mercenaires. | Sans titre ni terre, %name% cherche à rejoindre le genre d\'hommes dont il était le seigneur. | Même si cet ancien noble est bien équipé, vous remarquez que la pièce d\'équipement la plus utilisée de %name% sont ses bottes.}";
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
				-2
			],
			Stamina = [
				-10,
				-5
			],
			MeleeSkill = [
				8,
				10
			],
			RangedSkill = [
				3,
				6
			],
			MeleeDefense = [
				0,
				3
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/shortsword"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/militia_spear"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/shields/buckler_shield"));
		}

		r = this.Math.rand(0, 5);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/mail_shirt"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/mail_hauberk"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}

		r = this.Math.rand(0, 8);

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
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});

