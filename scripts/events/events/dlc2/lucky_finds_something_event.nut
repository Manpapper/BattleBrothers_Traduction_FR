this.lucky_finds_something_event <- this.inherit("scripts/events/event", {
	m = {
		Lucky = null,
		FoundItem = null
	},
	function create()
	{
		this.m.ID = "event.lucky_finds_something";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{%lucky% le mercenaire toujours chanceux, a réussi à trouver quelque chose d\'intéressant. Vous lui demandez comment il a trouvé l\'objet. Il hausse les épaules.%SPEECH_ON%{Je marchais, et j\'ai marché dessus. Assez simple. | J\'ai levé les yeux et cet oiseau a chié et m\'a manqué de peu. Quand j\'ai regardé où il avait atterri, eh bien, c\'était là. La merde d\'oiseau et cette chose que vous avez dans vos mains. | J\'ai senti un picotement dans mes doigts, et puis un autre dans ma bite. Après cela, j\'ai commencé à chercher quelque chose d\'ennuyeux pour m\'absoudre et j\'ai vu qu\'il était là. | J\'ai vu un fer à cheval par terre et j\'ai pensé aller le chercher et, eh bien, c\'était en dessous. | J\'ai vu ce trèfle à quatre feuilles posé là et j\'allais le ramasser, j\'en ai des douzaines, mais quand je suis allé le chercher, j\'ai vu cet objet posé là. Plutôt chouette, hein?}%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous avez de la chance.",
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
					text = "Vous recevez " + this.Const.Strings.getArticle(_event.m.FoundItem.getName()) + _event.m.FoundItem.getName()
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

