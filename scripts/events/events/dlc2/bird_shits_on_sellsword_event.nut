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
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{En parcourant la contrée, %birdbro% est atteint par une fiente d\'oiseau. Elle frappe le mercenaire et éclabousse son armure de part en part.%SPEECH_ON%Aww, awwww!%SPEECH_OFF%Ses bras s\'écartent comme des ailes de poulet alors qu\'il regarde les dégâts.%SPEECH_ON%Putain, c\'est bien ma chance!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ouais, ne vous attardez pas sur ça et continuons.",
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
						Text = "Serait-ce un présage?",
						function getResult( _event )
						{
							return "Superstitious";
						}

					});
				}

				if (_event.m.Archer != null)
				{
					this.Options.push({
						Text = "Que quelqu\'un fasse tomber ce transgresseur à plume!",
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
			Text = "%terrainImage%{%birdbro% hochement de tête.%SPEECH_ON%Evidemment. J\'ai juste gâché ma journée, c\'est tout.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ah bien.",
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
			Text = "%terrainImage%{Le superstitieux %superstitieux% analyse la merde avec l\'œil expert d\'un vrai bijoutier. Il se pince les lèvres et hoche la tête, un résumé aussi complet que possible d\'une merde d\'oiseau. il dit.%SPEECH_ON%C\'est une bonne chose.%SPEECH_OFF%Face à une compagnie très incrédule, l\'homme explique calmement que se faire chier dessus par un oiseau est un présage de bonnes choses à venir. Quelques mercenaires semblent convaincus par cette idée. Il est assez spectaculaire qu\'un oiseau vous choisisse, parmi toutes les autres possibilités qu\'il avait. Vous hochez la tête et dites à %birdbro% qu\'il devrait ouvrir la bouche la prochaine fois pour avoir plus de chance.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Un gars chanceux.",
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
			Text = "[img]gfx/ui/events/event_10.png[/img]{%archer% lève la tête, la main au dessus des yeux, la langue tirée. Il voit l\'oiseau et fait un signe de tête. Il se lèche un doigt, le met en l\'air, et hoche à nouveau la tête. L\'archer sourit en encochant une flèche.%SPEECH_ON%Pas de crime sans châtiment.%SPEECH_OFF%Les mercenaires grognent et se moquent de la vision moralisatrice de l\'homme, mais celui-ci lève calmement son arc et décoche la flèche. Elle s\'envole à très grande vitesse dans les airs, vous voyez l\'oiseau s\'incliner soudainement sur le côté et commencer à tournoyer vers le sol. Le tireur d\'élite hoche la tête et regarde la compagnie.%SPEECH_ON%Vous riez maintenant ?%SPEECH_OFF%Cela n\'amène que des huées supplémentaires. L\'archer fait un commentaire narquois sur son importance, ce qui provoque un débat sain entre les hommes qui se trouvent en première ligne et ceux qui sont à l\'arrière. Vous dites aux hommes que s\'ils veulent discuter de la meilleure solution, ils peuvent le prouver sur le champ de bataille.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Joli tir!",
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
			Text = "%terrainImage%{Vous dites à %birdbro% que de se faire emmerder fait partie de la vie et préparez la compagnie à reprendre la route. Mais un modeste %historian% se présente et dit au malheureux mercenaire d\'attendre avant de nettoyer la merde. L\'historien jette un bon coup d\'œil à cette merde, puis à l\'oiseau qui en est l\'auteur.%SPEECH_ON%Oui, oui... je connais cet oiseau! Cette créature magique!%SPEECH_OFF%Les hommes lèvent les yeux vers l\'oiseau comme s\'ils étaient des marins en quête de terres promises. %historian% pointe du doigt %birdbro%.%SPEECH_ON%Vous vous êtes fait chier dessus par un oiseau moqueur rouge et bleu ! C\'est tout ce que je voulais dire, vraiment. Je n\'en avais pas vu depuis un moment. Vous... vous pouvez nettoyer maintenant.%SPEECH_OFF%Les mercenaires restent bouche bée avant d\'éclater de rire. %birdbro% attrape l\'historien et utilise ses manches pour nettoyer la merde, ce qui provoque de nouveaux rires chez les hommes.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ce mystère est donc résolu.",
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

