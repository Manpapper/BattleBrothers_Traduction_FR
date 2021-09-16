this.lucky_finds_something_event <- this.inherit("scripts/events/event", {
	m = {
		Lucky = null,
		FoundItem = null
	},
	function create()
	{
		this.m.ID = "event.lucky_finds_something";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{%lucky% the ever lucky sellsword has managed to find something interesting. You ask how he came across the item. He shrugs.%SPEECH_ON%{I was walking, and then I stepped on it. Simple enough. | I looked up and this bird shat and it just missed me. When I looked at where it landed, well, there it was. The bird shit and that thing you got in your hands. | Felt a tingle in my fingers, and then a tingle in my cock. After that I got to looking around for somethin\' boring to absolve myself and saw it just settin\' there. | Saw a horseshoe just layin\' on the ground there and thought to go and fetch it and, well, that was underneath. | Well, see, I saw this four-leaf clover just setting there and I was gonna add it to my bag, see, I got dozens, anyway when I went to go pick it up I saw that item just settin\' there. Pretty nifty, huh?}%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lucky you.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Lucky.getImagePath());
				this.World.Assets.getStash().add(_event.m.FoundItem);
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.FoundItem.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(_event.m.FoundItem.getName()) + _event.m.FoundItem.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.lucky"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Lucky = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
		local item;
		local r = this.Math.rand(1, 19);

		if (r == 1)
		{
			item = this.new("scripts/items/weapons/militia_spear");
		}
		else if (r == 2)
		{
			item = this.new("scripts/items/armor/patched_mail_shirt");
		}
		else if (r == 3)
		{
			item = this.new("scripts/items/helmets/dented_nasal_helmet");
		}
		else if (r == 4)
		{
			item = this.new("scripts/items/helmets/mail_coif");
		}
		else if (r == 5)
		{
			item = this.new("scripts/items/helmets/cultist_hood");
		}
		else if (r == 6)
		{
			item = this.new("scripts/items/helmets/full_leather_cap");
		}
		else if (r == 7)
		{
			item = this.new("scripts/items/armor/ragged_surcoat");
		}
		else if (r == 8)
		{
			item = this.new("scripts/items/armor/noble_tunic");
		}
		else if (r == 9)
		{
			item = this.new("scripts/items/misc/ghoul_horn_item");
		}
		else if (r == 10)
		{
			item = this.new("scripts/items/weapons/knife");
		}
		else if (r == 11)
		{
			item = this.new("scripts/items/misc/wardog_armor_upgrade_item");
		}
		else if (r == 12)
		{
			item = this.new("scripts/items/armor_upgrades/joint_cover_upgrade");
		}
		else if (r == 13)
		{
			item = this.new("scripts/items/tools/throwing_net");
		}
		else if (r == 14)
		{
			item = this.new("scripts/items/weapons/throwing_spear");
		}
		else if (r == 15)
		{
			item = this.new("scripts/items/weapons/hatchet");
		}
		else if (r == 16)
		{
			item = this.new("scripts/items/weapons/lute");
		}
		else if (r == 17)
		{
			item = this.new("scripts/items/armor/thick_dark_tunic");
		}
		else if (r == 18)
		{
			item = this.new("scripts/items/armor_upgrades/mail_patch_upgrade");
		}
		else if (r == 19)
		{
			item = this.new("scripts/items/misc/paint_black_item");
		}

		if (item.getConditionMax() > 1)
		{
			item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 40) * 0.01));
		}

		this.m.FoundItem = item;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"lucky",
			this.m.Lucky.getNameOnly()
		]);
		_vars.push([
			"finding",
			this.Const.Strings.getArticle(this.m.FoundItem.getName()) + this.m.FoundItem.getName()
		]);
	}

	function onClear()
	{
		this.m.Lucky = null;
		this.m.FoundItem = null;
	}

});

