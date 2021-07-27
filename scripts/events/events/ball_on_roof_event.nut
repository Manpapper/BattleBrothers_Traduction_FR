this.ball_on_roof_event <- this.inherit("scripts/events/event", {
	m = {
		Surefooted = null,
		Other = null,
		OtherOther = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.ball_on_roof";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 140.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]La compagnie rencontre un petit garçon qui a grimpé dans un arbre et est arrivé au bord d\'une branche. Il essaie d\'attraper une balle qui est restée coincée sur le toit de sa maison. Vous n\'apercevez pas ces parents dans les environs pour l\'aider. Quand il vous voit, il demande si vous pouvez l\'aider à récupérer le ballon. Cela semble assez simple.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Je suppose que nous pouvons l\'aider.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 70)
						{
							return "Good";
						}
						else
						{
							return "Bad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Surefooted != null)
				{
					this.Options.push({
						Text = "%surefooted%, tu as le pied sûr. Donnes-lui un coup de main.",
						function getResult( _event )
						{
							return "Surefooted";
						}

					});
				}

				this.Options.push({
					Text = "Nous n\'avons pas le temps pour ça.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "[img]gfx/ui/events/event_97.png[/img]Vous envoyez %otherbrother% pour essayer de récupérer le ballon. Utilisant %otherother% comme échelle, il se lance sur le toit et récupère le jouet. Le garçon est aux anges et le sourire sur son visage réchauffe même le plus cynique de vos mercenaires.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quel bon mercenaire samaritain.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Other.improveMood(1.0, "A aidé un petit garçon");

				if (_event.m.Other.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_97.png[/img]Vous envoyez %otherbrother% pour essayer de récupérer le ballon. Il grimpe à l\'arbre et saute par-dessus une branche pour atterrir sur le toit. Mission accomplie, il lance la balle au gamin. Malheureusement, le garçon lâche la branche de l\'arbre pour essayer de l\'attraper. Il glisse de la branche et tombe d\'environ 5 mètres  sur le sol. Le choc de son atterrissage fait reculer toute la compagnie. WQuand vous l\'examinez, il ne bouge pas et son dos a pris une nouvelle posture. %otherother% crie à l\'idiot encore debout en état de choc sur le toit.%SPEECH_ON%A quoi tu pensais, bordel? Putain de merde, mec !%SPEECH_OFF%Le mercenaire descend du toit. Il regarde l\'enfant, puis regarde nerveusement autour de lui.%SPEECH_ON%Eh bien, il, euh, il a la balle. Fichons le camp d\'ici. Notre... notre travail ici est terminé.%SPEECH_OFF%Quelle situation de merde. Vous et la compagnie quittez rapidement les lieux avant que les parents ne reviennent.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Personne n\'a rien vu.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				this.Characters.push(_event.m.OtherOther.getImagePath());
				_event.m.Other.worsenMood(1.5, "A accidentellement estropié un petit garçon");

				if (_event.m.Other.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Surefooted",
			Text = "[img]gfx/ui/events/event_97.png[/img]%surefooted% se racle la gorge et s\'avance.%SPEECH_ON%Je serai ton héros, petit.%SPEECH_OFF%Il ouvre ses bras et le gamin saute dedans. Le garçon est mis de côté et le meercenairee pointe un doigt vers la terre.%SPEECH_ON%Reste en bas.%SPEECH_OFF%Le mercenaire au pied sûr grimpe facilement à l\'arbre et saute sur le toit. Il ramasse le ballon et le fait tourner sur un doigt avant de pirouetter du toit comme une tornade, atterrissant sur ses orteils avec une grâce de félin. Le garçon applaudit avec enthousiasme et prend le jouet, et même les hommes les plus cyniques de la compagnie sont réchauffés par son bonheur.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Frimeur.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Surefooted.getImagePath());
				_event.m.Surefooted.improveMood(1.5, "A impressionné tout le monde par ses talents");

				if (_event.m.Surefooted.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Surefooted.getMoodState()],
						text = _event.m.Surefooted.getName() + this.Const.MoodStateEvent[_event.m.Surefooted.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_surefooted = [];
		local candidates_other = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.sure_footing"))
			{
				candidates_surefooted.push(b);
			}
			else if (b.getSkills().hasSkill("trait.player"))
			{
				candidates_other.push(b);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_surefooted.len() != 0)
		{
			this.m.Surefooted = candidates_surefooted[this.Math.rand(0, candidates_surefooted.len() - 1)];
		}

		do
		{
			this.m.OtherOther = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
		while (this.m.OtherOther == null || this.m.OtherOther.getID() == this.m.Other.getID());

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
		_vars.push([
			"otherother",
			this.m.OtherOther.getName()
		]);
		_vars.push([
			"surefooted",
			this.m.Surefooted != null ? this.m.Surefooted.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Other = null;
		this.m.OtherOther = null;
		this.m.Surefooted = null;
		this.m.Town = null;
	}

});

