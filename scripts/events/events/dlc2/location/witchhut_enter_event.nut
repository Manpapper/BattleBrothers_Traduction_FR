this.witchhut_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.witchhut_enter";
		this.m.Title = "En approchant...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Vous vous arrêtez à la clairière de la forêt. La hutte devant vous se dresse comme une simple miette. Elle est si pittoresque et si facile à oublier qu\'on se demande comment elle a pu survivre, mais peut-être que sa totale banalité et sa nature discrète sont elles-mêmes une sorte d\'armure. Mais vous avez vécu assez longtemps dans ce monde pour savoir qu\'il faut faire confiance à son instinct, et pour l\'instant votre instinct vous dit d\'attendre.\n\n Très vite, la porte de la hutte s\'ouvre et une vieille femme sort en boitant. Elle fait immédiatement un signe dans votre direction.%SPEECH_ON%Vous, et seulement vous.%SPEECH_OFF%Perplexe, pourquoi seulement vous? Ou plus particulièrement, pourquoi avez-vous lui fait confiance pour commencer. Elle sourit.%SPEECH_ON%Parce que je sais ce dont rêve le faux roi la nuit.%SPEECH_OFF%Les mercenaires qui vous entourent se retournent et demandent ce qu\'elle a dit. Vous levez la main et leur dites de rester sur place pendant que vous allez discuter avec la mystérieuse femme.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Restez ici et soyez sur vos gardes.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Vous entrez, épée au poing, pour trouver la femme qui vous offre un bol de ragoût. Elle suggère que ce n\'est que du lapin et des pommes de terre, et plus le premier que le second. Rengainant votre épée, vous prenez le bol et prenez place à une table avec elle en face de vous. Quelques bougies brûlent à proximité, des glyphes sont peints en blanc sur les murs et des formes similaires sont suspendues au plafond comme des capteurs de rêves. La femme pose ses coudes sur la table. Des babioles sont enroulées dans ses cheveux, des barrettes d\'os d\'oiseaux et des plumes. Elle a un visage usé par le temps, mais ses yeux sont jeunes comme des perles qui scintillent au fond d\'un marais.%SPEECH_ON%Je savais que vous viendriez, comme un papillon de nuit vers la lumière, cherchant la vérité qui ne peut être apprivoisée.%SPEECH_OFF%Repoussant le bol sur la table, vous lui demandez si elle est une sorcière. Elle fait un signe de tête affirmatif et vous regarde fixement avant de hocher à nouveau la tête.%SPEECH_ON%Bien. Vous ne m\'avez pas tué, ce qui signifie que vous réfléchissez maintenant. Je suis en effet une soi-disant sorcière, mais je suis seule. Entièrement seule. Et traquée par les autres. Vous pouvez les appeler mes \"soeurs\", mais ces autres savent qui vous êtes, tout comme moi, et ils veulent votre sang. Ils peuvent le sentir et c\'est pourquoi je veux parler.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Qu\'est-ce que vous voulez ?",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_115.png[/img]{La femme dégaine un long objet enveloppé dans une nappe et le pose sur la table. Elle retire la nappe pour révéler une lame d\'obsidienne dentelée avec une bande de cuir en guise de poignée.%SPEECH_ON%Coupez votre chair et saignez dans cette obscurité. Les hexen et leur basse besogne viendront, et alors vous les tuerez toutes. Après cela, nous pourrons parler. L\'épée et la sorcière, la sorcière et l\'épée.%SPEECH_OFF%Vous demandez ce qu\'il y a pour vous. La sorcière glousse.%SPEECH_ON%Oh mercenaire, vous n\'êtes pas dans le business de la loyauté, mais dans le business de l\'or, et avec un habile tour de monnaie vous savez qu\'un ami peut se transformer en ennemi. Mais j\'offre quelque chose de plus. Une vérité qui ne peut être vue, une vérité pour le faux roi.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous avons déjà fait tout ce chemin.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_115.png[/img]{La lame noire repose dans votre main, et votre reflet se pose en dents de scie dans ses rainures de pierre, étiré et tiré dans chaque creux et bord. C\'est une simple pierre. Une simple dague. C\'est tout. Elle n\'est pas du tout lourde, mais vous pouvez sentir son importance, comme la poussière jetée sur une tombe, il n\'y a pas tant de poids dans le sable que dans le jet lui-même. Cette lame est soit une erreur soit un avantage et il n\'y a qu\'un seul moyen de savoir lequel. La sorcière hoche la tête. Vous acquiescez et vous vous entaillez le bras. Le sang s\'écoule sur la pierre et vos reflets disparaissent sous la couleur pourpre. Presque en grognant, la sorcière se penche avec empressement et presse la lame contre votre peau.%SPEECH_ON%Plus. Plus, mercenaire. Plus!%SPEECH_OFF%Vous tailladez encore puis vous fléchissez. Une giclée frappe la pierre. Elle prend le couteau et passe un tissu immaculé sur la plaie.%SPEECH_ON%C\'est bon, mercenaire. Allez rejoindre vos hommes et préparez-vous.%SPEECH_OFF%Vous vous levez et regardez la femme. Vous demandez.%SPEECH_ON%Et une fois que j\'aurai tué vos ennemis, on pourra reparler ensemble?%SPEECH_OFF%Elle sourit.%SPEECH_ON%Dans d\'autres termes, oui.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alors je le ferai.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Vous sortez et informez la compagnie que les hostilités sont en route. Assez rapidement, des femmes hagards sont aperçues marchant entre les arbres de la forêt, leurs longs ongles grattant l\'écorce et leurs lèvres baveuses grimaçant pour renifler et glousser. La première à arriver a une longue tête en forme de canoë. Un crâne d\'enfant pend à son collier, et un sac en cuir rebondit sur sa hanche, deux pattes de lapin dépassant de la poche. Elle jette un coup d\'œil à la hutte et renifle l\'air, puis tourne son regard vers vous.%SPEECH_ON%Ah, vous avez fait un pacte avec cette salope?%SPEECH_OFF%Vous acquiescez.%SPEECH_ON%Le marché a été conclu, oui, et il se terminera par votre mort au bout de cette lame. Et je crois qu\'elle préfère qu\'on l\'appelle simplement \"sorcière\".%SPEECH_OFF%Un autre hexen s\'avance.%SPEECH_ON%Nous préférons l\'appeler pétasse. Tuez les mercenaires. Prenez le capitaine vivant, mais enlevez-lui les yeux et cette langue minable.%SPEECH_OFF%La multitude de sorcières se précipite sur vous, certaines se transformant déjà en jeunes filles à l\'allure obscène tandis que d\'autres agitent leurs bras selon des rites spirituels.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Au combat!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setAttackable(true);
						}

						this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Events.showCombatDialog(true, true, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

