this.witchhunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.witchhunter";
		this.m.Name = "Witchhunter";
		this.m.Icon = "ui/backgrounds/background_23.png";
		this.m.BackgroundDescription = "Witchhunters tend to have some martial experience, and their resolve often remains unbroken even in the face of unspeakable horror.";
		this.m.GoodEnding = "%name% the witchhunter eventually heard word of evil spreading in northern villages. He departed the %companyname% and has been burning those horrid witches at the stake ever since.";
		this.m.BadEnding = "Word of evil spreading in the north drew %name% the witchhunter from the company. He departed with stakes, vials of strange liquids, and a lot of kindling. A month later a peasant found him wandering the northern wastes with his eyes gouged out and his mouth sewn shut. He had a strange symbol ironed into his chest and when the peasant touched it both men exploded.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 13;
		this.m.Excluded = [
			"trait.weasel",
			"trait.teamplayer",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.hate_beasts",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.insecure",
			"trait.hesitant",
			"trait.craven",
			"trait.fainthearted",
			"trait.dumb",
			"trait.superstitious",
			"trait.drunkard"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(1, 3);
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
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Resolve at morale checks against fear, panic or mind control effects"
			}
		];
	}

	function onBuildDescription()
	{
		return "{%name% appeared one day in %townname%, some say upon request {of the local council | of a local priest}. | %name% has a reputation of showing up where things out of the ordinary happen and being out and about at the darkest part of the night. | Being a quiet and grim man, %name% has the tendency to make other people feel uncomfortable around him, even afraid. | The name of %name% is known in many a village, for he has travelled the land to wherever his talents are needed the most.} {A Witchhunter he calls himself. With his assortment of exotic tools he has a great deal of experience in getting people to confess in agony their sinful liaisons with demons and devils under terrible torture. | He refers to himself as a Witchhunter, but only superstitious fools would believe this and fall for his preposterous tales. | A Witchhunter he calls himself, and he claims to have seen horrors from beyond that would drive a lesser man insane. | After his arrival in %townname%, rumors spread that he was on the hunt for devil worshippers and creatures of the night, but no one knew what the real purpose of his visit was. | In %townname% he killed an elderly woman and was thrown into the dungeon. As it turned out, the woman was responsible for the abduction and death of 3 infants, and so he was set free again. | For nights on end he sat in %townname%\'s pub, silently studying every patron like a bird of prey circling above, his crossbow never far away. It didn\'t sit well with the residents  but they didn\'t dare approach him.} {By now most of the local folks want %name% to be gone rather sooner than later and would happily see him join a travelling mercenary company. | It seems that whatever his mission was is now accomplished and so %name% offers his service as a mercenary. | It is somewhat obvious that %name% is not easily scared and he also knows how to handle a crossbow. Nobody was therefore surprised as he approached a mercenary company that was hiring. | Now, a mercenary company would be just the tool he needed to fulfill his personal quest against the evil from the world beyond. | Most people would be glad to get rid of him.}";
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

		if (this.Math.rand(1, 100) <= 25)
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
				12,
				10
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
				15,
				8
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
			actor.setTitle(this.Const.Strings.WitchhunterTitles[this.Math.rand(0, this.Const.Strings.WitchhunterTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/light_crossbow"));
		}
		else
		{
			items.equip(this.new("scripts/items/weapons/crossbow"));
		}

		items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.addToBag(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/witchhunter_hat"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.MoraleCheckBravery[1] += 20;
	}

});

