this.anatomist_dead_knight_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Noble = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_dead_knight";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_75.png[/img]{%anatomiste% l\'anatomiste aperçoit quelque chose de brillant un peu à l\'écart du chemin principal. Vous vous approchez et jetez un coup œil. Il y a quelque chose de sombre et métallique au loin. Peut-être le cadavre d\'un chevalier? Vous vous demandez comment il est arrivé là tout seul. %anatomiste% se demande à voix haute si l\'on ne pourrait pas apprendre quelque chose de ce corps voué à la guerre. Vous secouez la tête.%SPEECH_ON%Les chevaliers meurent rarement seuls, et s\'ils le font, ils ne gardent certainement pas leur armure avec eux. Ça sent le piège à plein nez.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "On va aller voir.",
					function getResult( _event )
					{
						if (_event.m.Noble != null)
						{
							return "C";
						}
						else if (this.World.FactionManager.isUndeadScourge())
						{
							return "E";
						}
						else if (this.Math.rand(1, 100) <= 30)
						{
							return "D";
						}
						else
						{
							return "B";
						}
					}

				},
				{
					Text = "Laissons-le de côté.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Au mépris du bon sens, vous allez jeter un coup d\'œil. Vous vous sentez tout nu en traversant le terrain à découvert jusqu\'au chevalier, comme un voleur qui dérobe en tendant la main jusqu\'à l\'autre bout de l\'allée. Quand vous arrivez au niveau du chevalier, vous faites une pause et regardez autour de vous. Aucun mouvement dans les parages. Pas de bandits en embuscade. Pas de meute de loups cherchant sa proie. Vous haussez les épaules et baissez les yeux. L\'homme est revêtu d\'une armure décente et porte une belle épée, bien qu\'usée. Son visage est desséché et ses yeux ont disparu. Des croûtes de merde d\'oiseau séchés son présentes sur une éraflure de son armure. Vous ordonnez à %anatomist% de le sortir de l\'armure et de ramener le tout dans le chariot.%SPEECH_ON%Quoi? Pourquoi dois-je le faire?%SPEECH_OFF%Vous lui dites que s\'il veut étudier le corps, il doit d\'abord retirer l\'armure. En partant, vous lui dites que lorsqu\'il le mettra dans l\'inventaire, il devra s\'assurer de ne pas écraser les aliments, car cette armure a l\'air un peu lourde. Assurez-vous aussi de nettoyer la merde d\'oiseaux. %anatomist% soupire, mais il est toujours heureux de pouvoir accéder au cadavre d\'un héros. Vous vous demandez parfois ce que l\'anatomiste ferait s\'il vous trouvait mort comme ça...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est assez simple.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local armor_list = [
					"decayed_coat_of_scales",
					"decayed_reinforced_mail_hauberk"
				];
				local item = this.new("scripts/items/armor/" + armor_list[this.Math.rand(0, armor_list.len() - 1)]);
				item.setCondition(item.getConditionMax() / 2 - 1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/arming_sword");
				item.setCondition(item.getConditionMax() / 2 - 1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Anatomist.improveMood(0.75, "Got to examine the corpse of a heroic knight");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Vous vous dirigez vers l\'armure qui, vous l\'espérez, n\'est pas du tout le piège auquel il ressemble. %anatomiste% est pratiquement au niveau de votre hanche, ses yeux dévorant la \"science\" potentielle qui se présente à lui, ses mains porte un tome ouvert dans lequel il écrit déjà avec ferveur.\n\nÉtonnamment, %noble% arrive, l\'homme d\'origine noble semblant reconnaître l\'armure elle-même. En effet, lorsque vous vous approchez, il s\'exclame qu\'il s\'agit d\'un de ses bons amis d\'autrefois. Vous acquiescez solennellement, mais dites quand même que l\'armure serait mieux utilisée au sein de la compagnie plutôt que de dépérir ici sur le sol. L\'homme acquiesce.%SPEECH_ON%Je pense que le chevalier serait d\'accord. Je vais la lui retirer.%SPEECH_OFF%Avant de commencer, %noble% se tourne vers %anatomiste% et lui dit qu\'il vaut mieux qu\'il évite de toucher son ami. Vous retournez au chariot avec l\'anatomiste, à qui vous aviez confié la tâche de porter l\'armure elle-même. L\'anatomiste, maintenant en sueur, est contrarié de ne pas avoir eu la chance de voir le cadavre et %noble% est visiblement mécontent que le cadavre lui-même soit l\'un de ses bons amis. Dans l\'ensemble, il semble que ce fichu mort ait causé plus de chagrin qu\'autre chose.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Au moins nous avons l\'armure.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Noble.getImagePath());
				local armor_list = [
					"armor/decayed_reinforced_mail_hauberk",
					"helmets/decayed_closed_flat_top_with_mail"
				];
				local item = this.new("scripts/items/" + armor_list[this.Math.rand(0, armor_list.len() - 1)]);
				item.setCondition(item.getConditionMax() / 2 - 1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Anatomist.worsenMood(1.0, "Was denied the opportunity to examine a promising corpse");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Noble.worsenMood(2.0, "Saw the decaying remains of an old friend");

				if (_event.m.Noble.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Noble.getMoodState()],
						text = _event.m.Noble.getName() + this.Const.MoodStateEvent[_event.m.Noble.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_21.png[/img]{Vous décidez d\'aller jeter un coup d\'oeil. En traversant la plaine apparemment dégagée, vous avez l\'impression d\'être observé. Il y a quelque chose qui ne va pas dans tout ça. À mi-chemin, vous vous tournez vers %anatomist% et lui dites qu\'il est temps de faire demi-tour. Il secoue la tête et dit que si vous êtes déjà allé si loin, pourquoi s\'arrêter maintenant? Avant que vous ne puissiez répondre, une flèche siffle à votre oreille et l\'anatomiste tombe à la renverse en se serrant l\'épaule.\n\nVous ramassez l\'homme et le traînez jusqu\'au chariot, les flèches atterrissant dans le sol autour de vous, des touffes de terre projetées sur vos bottes, jusqu\'à ce qu\'elles commencent à frapper le chariot lui-même. Rassemblant la compagnie pour une contre-attaque, vous voyez les prétendus ennemis prendre leurs distances et s\'enfuir, certains d\'entre eux portant l\'armure du chevalier avec eux. Comme vous le pensiez, tout cela n\'était qu\'un pot de miel pour les bandits. Heureusement, %anatomist% vivra, il écrit déjà dans son livre l\'expérience qu\'il vient de vivre ou peut-être, à en juger par sa fascination pour la flèche qui sort de lui, sur sa blessure macabre.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "La prochaine fois, j\'écouterai mon intuition.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local injury = _event.m.Anatomist.addInjury(this.Const.Injury.Accident2);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Anatomist.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Anatomist.improveMood(1.0, "Got to study an interesting wound up close");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_184.png[/img]{Au mépris du bon sens, vous allez jeter un coup d\\'œil. Vous vous sentez tout nu en traversant le terrain à découvert jusqu\'au chevalier, comme un voleur qui dérobe en tendant la main jusqu\'à l\'autre bout de l\'allée. En vous approchant du corps, vous vous retournez pour demander au %anatomiste% quels sont ses plans pour le cadavre. Vous voyez que l\'anatomiste se tient raide, la tête en arrière et les yeux grand ouverts, sa main nerveuse et agitée pointant l\'horizon. Vous regardez en arrière pour voir le cadavre bouger, ramper sur le sol, gémir, couiner. Le casque est projeté vers l\'avant et de la saleté se déverse par ses ouvertures. Vous dégainez votre épée.\n\nLe chevalier noir se soulève du sol, ses gantelets tombent pour révéler une chair blafarde. Il se retourne pour vous regarder. Son casque émet, par tous les orifices ,une faible lumière rouge. Vous abaissez votre épée et la tête de la créature se détache du corps, heurtant le sol tandis que de l\'air s\'échappe de son cou. Rengainant votre épée, vous dites à %anatomist% que s\'il veut quelque chose à étudier, eh bien, c\'est ici que cela se passe.%SPEECH_ON%Assurez-vous aussi de porter son armure jusqu\'au chariot. Veillez à utiliser vos jambes lorsque vous vous penchez, je ne veux pas que vous vous blessiez le dos ou autre.%SPEECH_OFF%Vous passez devant l\'anatomiste. Il vous regarde, bouche bée, puis ferme la bouche et sort une plume d\'oie et quelques parchemins. Sa peur s\'efface et il redevient lui-même.%SPEECH_ON%Un spécimen frais, de près, récemment décédé, ou peut-être est-il re-décédé ? Quoi qu\'il en soit... nous pouvons apprendre tellement de choses de cette expérience.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous pouvez aussi apprendre à vous pencher avec vos genoux, et que ça saute!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local armor_list = [
					"armor/decayed_reinforced_mail_hauberk",
					"helmets/decayed_closed_flat_top_with_mail"
				];
				local item = this.new("scripts/items/" + armor_list[this.Math.rand(0, armor_list.len() - 1)]);
				item.setCondition(item.getConditionMax() / 2 - 1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		if (this.World.getTime().Days <= 25)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local noble_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().isNoble())
			{
				noble_candidates.push(bro);
			}
		}

		if (noble_candidates.len() > 0)
		{
			this.m.Noble = noble_candidates[this.Math.rand(0, noble_candidates.len() - 1)];
		}

		if (anatomist_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.Score = 5 + anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"noble",
			this.m.Noble != null ? this.m.Noble.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Noble = null;
	}

});

