this.killer_vs_others_event <- this.inherit("scripts/events/event", {
	m = {
		Killer = null,
		OtherGuy1 = null,
		OtherGuy2 = null
	},
	function create()
	{
		this.m.ID = "event.killer_vs_others";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]Alors que vous tentez d\'étudier des cartes mal dessinées, le bruit de lames tirées vous perce les oreilles. Vous enroulez votre travail et le rangez dans la pochette ovale avant de vous frayer un chemin jusqu\'à la perturbation.\n\n%killerontherun% est maintenu au sol par le genou d\'un frère d\'armes, tandis que %otherguy1% et %otherguy2% semblent prêts à lui couper la tête. En voyant votre arrivée, les hommes se calment un instant. Ils expliquent que le tueur a essayé de tuer l\'un d\'entre eux. En effet, le confrère a une entaille dans le cou. Un peu plus profond et c\'est autre chose que des mots qui sortiraient de sa bouche en ce moment même. Les hommes demandent que %killerontherun% soit pendu pour cette tentative de meurtre.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Qu\'il soit fouetté pour ça.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Qu\'on le pende pour ça.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "C\'est ta famille maintenant. N\'ose plus jamais faire une telle chose !",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 3);

						if (r == 1)
						{
							return "D";
						}
						else if (r == 2)
						{
							return "E";
						}
						else
						{
							return "F";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_38.png[/img]Vous ordonnez que l\'homme soit fouetté. %killerontherun% crache sur votre nom alors que les frères d\'armes l\'attachent à un arbre. Vous dites \"refais-le et tu te ajouteras des coups de fouet\". Ils lui arrachent sa chemise et se relaient avec le fouet pendant que vous vous tenez sur le côté, en comptant. Au premier coup de fouet, une ligne droite de peau est arrachée de son dos. L\'homme tressaille et vous entendez les cordes qui le lient se tendre tandis que ses mains se crispent en poings. Au cinquième coup de fouet, il ne se tient plus debout. Au dixième, il n\'est plus éveillé. Après cinq autres coups de fouet, vous ordonnez aux hommes de le descendre et de soigner ses blessures.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'espère qu\'il aura appris la leçon.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
				_event.m.Killer.addLightInjury();
				_event.m.Killer.worsenMood(3.0, "A été fouetté sur vos ordres");
				this.List = [
					{
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Killer.getName() + " souffre de blessures légères"
					}
				];

				if (_event.m.Killer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Killer.getMoodState()],
						text = _event.m.Killer.getName() + this.Const.MoodStateEvent[_event.m.Killer.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_02.png[/img]Vous ordonnez la pendaison de l\'homme. La moitié de la compagnie applaudit et %killerontherun% pousse un cri plutôt approprié pour quelqu\'un qui voit sa propre mort ordonnée. Ils traînent l\'homme sous un arbre. Des cordes sont jetées sur les branches, encore et encore, s\'enroulant et se tendant. Un homme noue un nœud coulant pendant que les autres applaudissent et boivent de la bière. Un tabouret est placé et le condamné est obligé de s\'y tenir debout. Alors que la tête de %killerontherun% est mise dans le nœud coulant, il dit qu\'il a un mot pour vous tous, mais ce qu\'il a à dire est coupé lorsque %otherguy1% fait tomber le tabouret de dessous lui.\n\nCe n\'est pas une bonne façon de mourir. C\'est par la main ou les moyens d\'un bourreau. D\'ordinaire, un homme lâché d\'une plate-forme se brise le cou, ou est même décapité. Cet homme se pend en s\'étouffant et en donnant des coups. On entend des cris dans ses poumons, mais ils ont du mal à passer la gorge. Quelques minutes passent et il se bat toujours. %otherguy2% s\'avance vers l\'homme mourant, saisit l\'un de ses pieds tremblants pour le maintenir immobile, et de sa main libre, il poignarde %killerontherun% en plein cœur. Et c\'est tout.\n\n{À la surprise générale, les mercenaires acceptent de détacher l\'homme et de l\'enterrer. | L\'homme est laissé en plan et la compagnie reprend son chemin.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous continuons.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Killer.getName() + " est mort"
				});
				_event.m.Killer.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.Killer.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.Killer);
				_event.m.OtherGuy1.improveMood(2.0, "Est satisfait par la pendaison de " + _event.m.Killer.getNameOnly());

				if (_event.m.OtherGuy1.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.OtherGuy1.getMoodState()],
						text = _event.m.OtherGuy1.getName() + this.Const.MoodStateEvent[_event.m.OtherGuy1.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]Alors que vous essayez de ramener la paix entre les membres du groupe, vos tentatives de neutralité ne fait qu\'irriter quelques-uns des hommes. En particulier, l\'homme au cou entaillé bouillonne, jure et donne des coups de pied dans le vide. Quelques-uns des autres hommes s\'inquiètent à voix haute du manque de discipline.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous continuons.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
				_event.m.OtherGuy1.worsenMood(4.0, "En colère contre le manque de justice sous votre commandement");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.OtherGuy1.getMoodState()],
					text = _event.m.OtherGuy1.getName() + this.Const.MoodStateEvent[_event.m.OtherGuy1.getMoodState()]
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Killer.getID() || bro.getID() == _event.m.OtherGuy1.getID())
					{
						continue;
					}

					bro.worsenMood(1.0, "Préoccupé par le manque de discipline");

					if (bro.getMoodState() < this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getNameOnly() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_64.png[/img]L\'appel à l\'apaisement semble avoir échoué, car le corps de %killerontherun% est quand même retrouvé mort. {Il semble que quelqu\'un l\'ait poignardé dans le dos. | Quelqu\'un a étranglé l\'homme avec une ligne de linge fort. | Il a été presque coupé en deux, l\'œuvre d\'une personne vraiment en colère. | Sa tête a été trouvée reposant sur sa poitrine, ses mains étant placées de manière à la tenir. | J\'insiste sur le mot \"corps\", car sa tête était introuvable. | Quelqu\'un lui avait tranché la gorge dans la nuit. | Les bleus sur son corps et les coupures sur ses mains suggèrent un combat, mais qui que ce soit, il a quand même réussi à étriper l\'homme.} Vous avez une bonne idée de qui a fait le coup, mais aucun des hommes ne semble vraiment bouleversé par la mort de l\'homme et une preuve certaine échapperait à toute sorte d\'enquête. Même si tout cela est vrai, vous ordonnez au suspect d\'aider à enterrer le mort.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il n\'y a plus rien à faire maintenant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				local dead = _event.m.Killer;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Assassiné par ses camarades",
					Expendable = dead.getBackground().getID() == "background.slave"
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Killer.getName() + " est mort"
				});
				_event.m.Killer.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.Killer.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.Killer);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.OtherGuy1.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						continue;
					}

					bro.worsenMood(1.0, "Préoccupé par le manque de discipline");

					if (bro.getMoodState() < this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "Eh bien, %killerontherun% n\'est pas mort, mais il se tient devant vous, brisé et battu. On dirait que la justice vengeresse l\'a quand même démasqué. Il demande que certains frères suspects soient punis pour avoir contourné vos ordres. Vous y réfléchissez, mais vous demandez ensuite à l\'homme ce qui se passera si vous continuez ce cycle de violence. Il est difficile de voir le visage de l\'homme, car il est gonflé de noir et de violet, et ses yeux sont perdus derrière des paupières plissées, mais il hoche la tête avec précaution. Vous avez raison, dit-il. Il vaut mieux laisser cette histoire se calmer, de peur qu\'elle ne devienne incontrôlable.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous continuons.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
				local injury = _event.m.Killer.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 13,
					icon = injury.getIcon(),
					text = _event.m.Killer.getName() + " souffre de " + injury.getNameOnly()
				});
				injury = _event.m.Killer.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 13,
					icon = injury.getIcon(),
					text = _event.m.Killer.getName() + " souffre de " + injury.getNameOnly()
				});
				_event.m.Killer.worsenMood(2.0, "A été battu par des hommes de la compagnie.");

				if (_event.m.Killer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Killer.getMoodState()],
						text = _event.m.Killer.getName() + this.Const.MoodStateEvent[_event.m.Killer.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Killer.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50 && bro.getID() != _event.m.OtherGuy1.getID())
					{
						continue;
					}

					bro.worsenMood(1.0, "Préoccupé par le manque de discipline");

					if (bro.getMoodState() < this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 10)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local killer_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getHireTime() + this.World.getTime().SecondsPerDay * 60 >= this.World.getTime().Time && bro.getBackground().getID() == "background.killer_on_the_run" && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				killer_candidates.push(bro);
			}
		}

		if (killer_candidates.len() == 0)
		{
			return;
		}

		this.m.Killer = killer_candidates[this.Math.rand(0, killer_candidates.len() - 1)];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Killer.getID() && bro.getBackground().getID() != "background.slave")
			{
				other_candidates.push(bro);
			}
		}

		if (other_candidates.len() == 0)
		{
			return;
		}

		this.m.OtherGuy1 = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Killer.getID() && bro.getID() != this.m.OtherGuy1.getID())
			{
				other_candidates.push(bro);
			}
		}

		if (other_candidates.len() == 0)
		{
			return;
		}

		this.m.OtherGuy2 = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"killerontherun",
			this.m.Killer.getName()
		]);
		_vars.push([
			"otherguy1",
			this.m.OtherGuy1.getName()
		]);
		_vars.push([
			"otherguy2",
			this.m.OtherGuy2.getName()
		]);
	}

	function onClear()
	{
		this.m.Killer = null;
		this.m.OtherGuy1 = null;
		this.m.OtherGuy2 = null;
	}

});

