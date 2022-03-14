this.lindwurm_slayer_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.lindwurm_slayer";
		this.m.Name = "Lindwurm Slayer";
		this.m.Icon = "ui/backgrounds/background_71.png";
		this.m.DailyCost = 28;
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.bleeder",
			"trait.bright",
			"trait.clubfooted",
			"trait.clumsy",
			"trait.craven",
			"trait.dastard",
			"trait.disloyal",
			"trait.fainthearted",
			"trait.fear_beasts",
			"trait.fragile",
			"trait.greedy",
			"trait.hate_greenskins",
			"trait.hate_undead",
			"trait.hesitant",
			"trait.impatient",
			"trait.insecure",
			"trait.irrational",
			"trait.night_blind",
			"trait.team_player",
			"trait.weasel"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
		return "";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				6,
				3
			],
			Bravery = [
				12,
				10
			],
			Stamina = [
				5,
				5
			],
			MeleeSkill = [
				8,
				8
			],
			RangedSkill = [
				10,
				8
			],
			MeleeDefense = [
				5,
				4
			],
			RangedDefense = [
				-3,
				-3
			],
			Initiative = [
				8,
				12
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
		local weapons = [
			"weapons/fighting_spear",
			"weapons/noble_sword"
		];
		items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));

		if (items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
		{
			items.equip(this.new("scripts/items/shields/buckler_shield"));
		}

		local armor = [
			"armor/mail_hauberk",
			"armor/reinforced_mail_hauberk"
		];

		if (this.Const.DLC.Unhold)
		{
			armor.extend([
				"armor/leather_scale_armor",
				"armor/noble_mail_armor",
				"armor/light_scale_armor",
				"armor/footman_armor"
			]);
		}

		items.equip(this.new("scripts/items/" + armor[this.Math.rand(0, armor.len() - 1)]));
		local helmets = [
			"helmets/feathered_hat",
			"helmets/headscarf",
			"helmets/mail_coif",
			"helmets/greatsword_hat"
		];
		items.equip(this.new("scripts/items/" + helmets[this.Math.rand(0, helmets.len() - 1)]));
	}

});

