this.kings_guard_1_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.kings_guard_1";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 9999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{The snowy wastes are home to not much of anything, so to find a man half-naked in its frigid geography is rather unusual. That he is actually alive even more so. You crouch beside him. His eyes are hollow and rime frosts make blinking them a struggle. His lips are jagged and purple. His nose a deep red bordering on black. You ask if he can speak. He nods.%SPEECH_ON%Barbarians. Took. Me.%SPEECH_OFF%You ask where his kidnappers are. He shrugs and continues his cold cadence.%SPEECH_ON%They. Got. Bored. And. Left.%SPEECH_OFF%It does seem in tune with the primitives to up and leave a prisoner in the ice. He explains that he was once a sturdy swordfighter. A smile squeezes  through the pain.%SPEECH_ON%A. King\'s. Guard. In. The. Kingless. Land. Things. Could. Be. Worse?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We have a place for you, friend.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "You\'re on your own in this world.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"cripple_background"
				], false);
				_event.m.Dude.setTitle("");
				_event.m.Dude.getBackground().m.RawDescription = "You found %name% frozen half to death in the north. He claims he was a King\'s Guard once, but looking at him now you see but a cripple.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getFlags().set("IsSpecial", true);
				_event.m.Dude.getBaseProperties().Bravery += 15;
				_event.m.Dude.getSkills().update();
				_event.m.Dude.m.PerkPoints = 2;
				_event.m.Dude.m.LevelUps = 2;
				_event.m.Dude.m.Level = 3;
				_event.m.Dude.m.XP = this.Const.LevelXP[_event.m.Dude.m.Level - 1];
				_event.m.Dude.m.Talents = [];
				local talents = _event.m.Dude.getTalents();
				talents.resize(this.Const.Attributes.COUNT, 0);
				talents[this.Const.Attributes.MeleeSkill] = 2;
				talents[this.Const.Attributes.MeleeDefense] = 3;
				talents[this.Const.Attributes.RangedDefense] = 3;
				_event.m.Dude.m.Attributes = [];
				_event.m.Dude.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.worsenMood(1.5, "Got taken by barbarians and left to die in the cold");
				_event.m.Dude.getFlags().set("IsKingsGuard", true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{You pat the man on his head, but tell him it\'s already over. He nods.%SPEECH_ON%Speak. For. Yourself. Mercenary.%SPEECH_OFF%He smiles again, but this time it does release. It sticks. Literally. And he leans forward and his eyes are open and do not blink and in this state he is gone. You get the men back on the road, or what one can make of a road in these snowed stretches.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It\'s already over for you.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%{The nearly frozen man joins the company. He\'s a ragged wreck, but if what he said is true maybe he will someday become the fighter he could barely speak of.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll see.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type != this.Const.World.TerrainType.Snow)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

