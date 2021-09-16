this.bird_shits_on_sellsword_event <- this.inherit("scripts/events/event", {
	m = {
		Victim = null,
		Superstitious = null,
		Archer = null,
		Historian = null
	},
	function create()
	{
		this.m.ID = "event.bird_shits_on_sellsword";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{While traveling the land, %birdbro% gets struck by birdshite. It hits his swordhand and splashes crosswise all over his armor.%SPEECH_ON%Aww, awwww!%SPEECH_OFF%His arms go wide like chicken wings as he looks at the damage.%SPEECH_ON%Bloody hell, just my luck!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Yeah, don\'t dwell on it and let\'s get going.",
					function getResult( _event )
					{
						if (_event.m.Historian == null)
						{
							return "Continue";
						}
						else
						{
							return "Historian";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());

				if (_event.m.Superstitious != null)
				{
					this.Options.push({
						Text = "Could this be an omen?",
						function getResult( _event )
						{
							return "Superstitious";
						}

					});
				}

				if (_event.m.Archer != null)
				{
					this.Options.push({
						Text = "Someone bring down that plumed transgressor!",
						function getResult( _event )
						{
							return "Archer";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Continue",
			Text = "%terrainImage%{%birdbro% nods.%SPEECH_ON%Course. Just ruined m\'day that\'s all.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ah well.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
				_event.m.Victim.worsenMood(0.5, "Got shit on by a bird");

				if (_event.m.Victim.getMoodState() <= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Victim.getMoodState()],
						text = _event.m.Victim.getName() + this.Const.MoodStateEvent[_event.m.Victim.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Superstitious",
			Text = "%terrainImage%{The ever superstitious %superstitious% analyzes the shit with the appraising eye of a proper jeweler. He purses his lips and nods, as satisfied a summary of bird shit as there ever was. He says.%SPEECH_ON%This is a good thing.%SPEECH_OFF%In the face of very incredulous company the man calmly explains that being shat on by a bird is an omen of good things to come. A few of the sellswords seem convinced by this notion. It is rather spectacular to have a bird choose you, out of all earth below, to land a squat on. You nod and say %birdbro% should open his mouth next time for extra special good fortune.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lucky guy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
				this.Characters.push(_event.m.Superstitious.getImagePath());
				_event.m.Victim.improveMood(1.0, "Got shit on by a bird for good luck");

				if (_event.m.Victim.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Victim.getMoodState()],
						text = _event.m.Victim.getName() + this.Const.MoodStateEvent[_event.m.Victim.getMoodState()]
					});
				}

				_event.m.Superstitious.improveMood(0.5, "Witnessed " + _event.m.Victim.getName() + " being shat on by a bird");

				if (_event.m.Superstitious.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Superstitious.getMoodState()],
						text = _event.m.Superstitious.getName() + this.Const.MoodStateEvent[_event.m.Superstitious.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Archer",
			Text = "[img]gfx/ui/events/event_10.png[/img]{%archer% looks up, hand shielded over his eyes, tongue out. He sees the bird and nods. He licks a finger, puts it to the air, and nods again. The archer grins as he nocks an arrow.%SPEECH_ON%With crime there is punishment.%SPEECH_OFF%The mercenaries groan and mock the man\'s moralizing, but he calmly raises the bow and lets the arrow loose. It zips and shrinks high into the air and you can hardly see the shot but you do see the bird suddenly crank sideways and start twirling to the earth. The sharpshooter nods and looks over at the company.%SPEECH_ON%You laughing now?%SPEECH_OFF%This only brings more jeers. The archer snidely comments about his importance and this brings about a healthy debate between the men who stand on the frontline and those in the back. You tell the men that if they want to argue which is better they can prove it on the battlefield.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nice shot!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
				this.Characters.push(_event.m.Archer.getImagePath());
				_event.m.Victim.improveMood(0.5, "Got revenge on a bird that shat on him");

				if (_event.m.Victim.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Victim.getMoodState()],
						text = _event.m.Victim.getName() + this.Const.MoodStateEvent[_event.m.Victim.getMoodState()]
					});
				}

				_event.m.Archer.improveMood(1.0, "Exacted revenge on a bird that shat on " + _event.m.Victim.getName() + " with pinpoint accuracy");

				if (_event.m.Archer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Archer.getMoodState()],
						text = _event.m.Archer.getName() + this.Const.MoodStateEvent[_event.m.Archer.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Archer.getID() || bro.getID() == _event.m.Victim.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Witnessed " + _event.m.Archer.getName() + "\'s fine display of archery");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Historian",
			Text = "%terrainImage%{You tell %birdbro% that being shit on is a part of life and get the company ready to get back on the road. But a modest %historian% comes up and tells the ill-fated sellsword to hold off on cleaning the shite. The historian takes a good look at the shite and then up at the bird which authored it.%SPEECH_ON%Yes, yes... I know that bird! That magical creature!%SPEECH_OFF%The men look up at the bird as though they were sealeagured sailors finding rarified land. %historian% points at %birdbro%.%SPEECH_ON%You got shat on by a red-and-blue mockingbird! That\'s all I wanted to say, really. I just hadn\'t seen one in awhile. You... you can clean it now.%SPEECH_OFF%The mercenaries stand slackjawed before bursting into laughter. %birdbro% grabs the historian and uses his sleeves to clean the shit off which brings more roars from the men.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "So that mystery is solved.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
				this.Characters.push(_event.m.Historian.getImagePath());
				_event.m.Victim.worsenMood(0.5, "Got shit on by a bird");

				if (_event.m.Victim.getMoodState() <= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Victim.getMoodState()],
						text = _event.m.Victim.getName() + this.Const.MoodStateEvent[_event.m.Victim.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Victim.getID() || bro.getID() == _event.m.Historian.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Felt entertained by " + _event.m.Historian.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
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

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type == this.Const.World.TerrainType.Snow)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_victim = [];
		local candidates_archer = [];
		local candidates_super = [];
		local candidates_historian = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.historian")
			{
				candidates_historian.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.superstitious"))
			{
				candidates_super.push(bro);
			}
			else if (bro.getBackground().getID() == "background.hunter" || bro.getCurrentProperties().RangedSkill > 70)
			{
				candidates_archer.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.lucky") && bro.getBackground().getID() != "background.slave")
			{
				candidates_victim.push(bro);
			}
		}

		if (candidates_victim.len() == 0)
		{
			return;
		}

		this.m.Victim = candidates_victim[this.Math.rand(0, candidates_victim.len() - 1)];

		if (candidates_historian.len() != 0)
		{
			this.m.Historian = candidates_historian[this.Math.rand(0, candidates_historian.len() - 1)];
		}

		if (candidates_archer.len() != 0)
		{
			this.m.Archer = candidates_archer[this.Math.rand(0, candidates_archer.len() - 1)];
		}

		if (candidates_super.len() != 0)
		{
			this.m.Superstitious = candidates_super[this.Math.rand(0, candidates_super.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"birdbro",
			this.m.Victim.getNameOnly()
		]);
		_vars.push([
			"superstitious",
			this.m.Superstitious != null ? this.m.Superstitious.getName() : ""
		]);
		_vars.push([
			"archer",
			this.m.Archer != null ? this.m.Archer.getName() : ""
		]);
		_vars.push([
			"historian",
			this.m.Historian != null ? this.m.Historian.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Victim = null;
		this.m.Superstitious = null;
		this.m.Archer = null;
		this.m.Historian = null;
	}

});

