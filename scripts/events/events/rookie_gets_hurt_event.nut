this.rookie_gets_hurt_event <- this.inherit("scripts/events/event", {
	m = {
		Rookie = null
	},
	function create()
	{
		this.m.ID = "event.rookie_gets_hurt";
		this.m.Title = "After battle...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_22.png[/img]Une fois la bataille terminée, vous trouvez %noncombat% à genoux, son corps se balançant d\'avant en arrière alors qu\'il soigne une blessure. Vous entendez des cris étouffés parmi des gémissements trop forts. En vous approchant, vous demandez à l\'homme s\'il va bien. Il secoue la tête et vous explique qu\'il s\'agissait de sa première expérience de combat réel et brutal. Ce n\'était pas ce à quoi il s\'attendait et il n\'est pas sûr de pouvoir continuer.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Faites-vous une raison !",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 30 ? "B" : "C";
					}

				},
				{
					Text = "Il n\'y a pas une âme ici qui ne soit pas effrayée.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "D" : "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Rookie.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_22.png[/img]Vous dites au mercenaire de se ressaisir. Quand il s\'arrête, étouffant un cri, vous lui répétez. Cette fois, il sort une jambe et plante un pied, pour se stabiliser. Avec beaucoup de courage, il parvient à se remettre debout. Sa chemise est ensanglantée, son visage couvert de boue, de cramoisi et d\'autres viscères que la bataille fait des vivants. Mais ses yeux montrent un signe de détermination qu\'ils n\'avaient pas auparavant. Il vous fait un signe de tête avant de retourner rejoindre le reste des hommes.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le fer aiguise le fer.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Rookie.getImagePath());
				_event.m.Rookie.improveMood(1.0, "A eu une discussion encourageante");
				_event.m.Rookie.getBaseProperties().Bravery += 3;
				_event.m.Rookie.getSkills().update();
				this.List = [
					{
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Rookie.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+3[/color] de Détermination"
					}
				];

				if (_event.m.Rookie.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Rookie.getMoodState()],
						text = _event.m.Rookie.getName() + this.Const.MoodStateEvent[_event.m.Rookie.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_22.png[/img]Malheureusement, lui dire de se ressaisir ne le mène nulle part. Il se tourne vers vous, le visage couvert du sang et du carnage de la bataille, mais avant que les mots puissent sortir, sa lèvre tremble et s\'effondre à nouveau. Vous demandez à l\'homme s\'il souhaite être renvoyé de la compagnie, mais il secoue la tête pour refuser. Il va s\'améliorer, explique-t-il. Vous acquiescez et vous partez, mais il ne fait aucun doute que cette piètre démonstration de détermination a blessé la fierté de l\'homme.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il sera endurci par le combat, ou il en mourra.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Rookie.getImagePath());
				_event.m.Rookie.getBaseProperties().Bravery -= 3;
				_event.m.Rookie.getSkills().update();
				this.List = [
					{
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Rookie.getName() + " perd [color=" + this.Const.UI.Color.NegativeEventValue + "]-3[/color] de Détermination"
					}
				];
				_event.m.Rookie.worsenMood(1.0, "A perdu confiance en lui");

				if (_event.m.Rookie.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Rookie.getMoodState()],
						text = _event.m.Rookie.getName() + this.Const.MoodStateEvent[_event.m.Rookie.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_22.png[/img]L\'homme regarde autour de lui, les corps, la terre, le ciel. Il hoche la tête et se lève. Avant de retourner au camp, il vous remercie pour vos paroles.%SPEECH_ON%Merci, capitaine. Je ferai mieux de cacher mes peurs.%SPEECH_OFF%Vous acquiescez avec un sourire laconique avant de mettre votre poing sur votre poitrine.%SPEECH_ON%Chargez vous de choses ici et ne laissez personne d\'autre le voir. La moitié d\'une bataille consiste à convaincre votre adversaire que vous êtes plus fou qu\'il ne l\'est. Être sans peur est impossible, mais faire semblant pour un temps ne l\'est pas.%SPEECH_OFF%L\'homme acquiesce à nouveau et retourne au camp avec la tête un peu plus haute.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est ça l\'esprit !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Rookie.getImagePath());
				_event.m.Rookie.improveMood(1.0, "A eu une discussion encourageante");
				_event.m.Rookie.getBaseProperties().Bravery += 2;
				_event.m.Rookie.getSkills().update();
				this.List = [
					{
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Rookie.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] de Détermination"
					}
				];

				if (_event.m.Rookie.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Rookie.getMoodState()],
						text = _event.m.Rookie.getName() + this.Const.MoodStateEvent[_event.m.Rookie.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_22.png[/img]L\'homme se tourne vers vous, des larmes perçant les croûtes de sang sur ses joues. Il secoue la tête et demande comment il se fait qu\'il soit le seul à pleurer ici. Vous haussez les épaules et demandez à l\'homme s\'il souhaite quitter la compagnie. Il secoue à nouveau la tête. %SPEECH_ON%Je deviendrais meilleur. J\'ai juste besoin de temps pour y arriver, c\'est tout.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il sera endurci par le combat, ou il en mourra.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Rookie.getImagePath());
				_event.m.Rookie.worsenMood(1.0, "A réalisé ce que ça signifie être un mercenaire");

				if (_event.m.Rookie.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Rookie.getMoodState()],
						text = _event.m.Rookie.getName() + this.Const.MoodStateEvent[_event.m.Rookie.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 10.0)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() == 1 && bro.getBackground().getID() != "background.slave" && !bro.getBackground().isCombatBackground() && bro.getPlaceInFormation() <= 17 && bro.getLifetimeStats().Battles >= 1)
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 1)
		{
			return;
		}

		this.m.Rookie = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 75;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noncombat",
			this.m.Rookie.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Rookie = null;
	}

});

