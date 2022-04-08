this.desertion_event <- this.inherit("scripts/events/event", {
	m = {
		Deserter = null,
		Other = null
	},
	function setDeserter( _d )
	{
		this.m.Deserter = _d;
		this.m.Other = null;
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() > 1)
		{
			do
			{
				this.m.Other = brothers[this.Math.rand(0, brothers.len() - 1)];
			}
			while (this.m.Other == null || this.m.Other.getID() == this.m.Deserter.getID());
		}
		else
		{
			this.m.Other = this.m.Deserter;
		}
	}

	function create()
	{
		this.m.ID = "event.desertion";
		this.m.Title = "Sur la route...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Le %desertedbrother% a déserté %companyname%. Quand les jours semblent interminables et la route plus longue, une autre sorte de qualité est mise au défi chez les hommes. Vous avez découvert que même ceux qui n\'ont peur de rien au combat n\'ont pas toujours l\'endurance nécessaire pour supporter la dureté de la vie de mercenaire. Et puis il y a les hommes qui sont à la fois lâches et fainéants. Vous ne pouvez qu\'espérer que vous ne gaspillez pas trop d\'argent avec ce genre d\'hommes avant de les découvrir.\n\n%otherbrother% steps up to you.%SPEECH_ON%Never mind about %desertedbrother%, sir. Never liked the look of him. Without the %companyname% to take care of him, I wager in a fortnight\'s time he\'ll be swinging from the gibbet.%SPEECH_OFF%%otherbrother% s\'approche de vous.%SPEECH_ON%Ne vous souciez pas de %desertedbrother%, monsieur. Personnellement je ne l\'ai jamais aimé. Sans %companyname% pour s\'occuper de lui, je parie que dans une quinzaine de jours il se balancera au bout d\'une potence.%SPEECH_OFF% | La critique est une tradition bien établie chez les mercenaires, et chez les gens en général, mais vous vous êtes rapidement lassé des plaintes incessantes de %desertedbrother%.\n\nSi les rations étaient périmées, la bière trop amère ou la viande trop dure, il était le premier à vous le faire savoir, à plusieurs reprises. Il en disait autant des pieds endoloris, du mauvais temps, des boucliers fragiles, des armures qui s\'irritent, de la caravane qui avance trop lentement, de la caravane qui avance trop vite, des lames émoussées, de l\'obtention du premier tour de garde, du pain moisi, de la faible rémunération, de l\'ennui général et des noctambules qui l\'empêchent de dormir à la nuit tombée. Ce n\'est pas la liste complète de ses doléances, mais c\'est tout ce dont tu te souviens pour le moment.\n\nLes plaintes de %desertedbrother% sont malheureusement le lot habituel de la troupe de mercenaires itinérants, et sont pour la plupart inévitables. Vous n\'êtes donc pas vraiment surpris lorsque vous apprenez que %desertedbrother% est parti pour une vie moins pénible. | Depuis plusieurs jours, %desertedbrother% ne met plus son cœur à courir vers une mort certaine et à écraser l\'ennemi devant lui. Ne l\'ayant pas vu au camp aujourd\'hui, les autres hommes vous disent qu\'il est allé chercher du bois de chauffage. Comme ce travail ne prend généralement pas douze heures, il semble que %desertedbrother% ait finalement décidé d\'emporter son mécontentement sur la route et de tenter sa chance ailleurs. Vous doutez que vous le reverrez. | Lors de vos récents voyages, la compagnie a malheureusement dû faire face à une série de mésaventures. Cela a touché %desertedbrother% plus durement que les autres. Il fait la grasse matinée, provoque des bagarres et se montre insubordonné. Et cela, quand vous pouvez le trouver. Tout cela ne l\'attire ni vers vous ni vers ses camarades, et cela n\'a pas arrangé les choses quand %otherbrother% a jeté le sac de couchage de %desertedbrother% dans le fossé que les frères utilisaient comme latrines.\n\nIl est généralement préférable de laisser les hommes exprimer leur mécontentement, et comme la compagnie n\'a pas eu de chance, vous avez été tolérant. Quand ce matin vous l\'avez trouvé parti, ce n\'était pas vraiment une surprise. %desertedbrother% a déserté %companyname%. | Vous êtes troublé d\'apprendre que %desertedbrother% semble avoir disparu pendant la nuit. Après avoir interrogé les autres et vous être assuré qu\'il ne s\'était pas simplement caché derrière un rocher pour faire ses besoins, vous lancez un avis de recherche. Pensant que %desertedbrother% avait peut-être été enlevé par traîtrise, kidnappé pour obtenir une rançon, ou qu\'il était tombé sur une bête, vous et les frères avez passé plusieurs heures à fouiller la zone et à appeler son nom.\n\nPuis %otherbrother% a finalement suggéré que %desertedbrother% n\'avait pas disparu du tout, mais qu\'il vous avait tous abandonnés. Il s\'est plaint de la compagnie ces derniers temps, mais je suppose qu\'il vous l\'a caché, monsieur, pour avoir une chance de s\'éclipser sans être vu.%SPEECH_OFF%Restraignant l\'envie de donner au porteur de mauvaises nouvelles une solide claque sur les oreilles, vous demandez pourquoi il ne s\'est pas présenté plus tôt, mais le frère n\'a pas de réponse. | Vous n\'avez jamais pensé que %desertedbrother% était du genre à déserter, mais quand l\'aube arrive et qu\'il n\'est plus là, vous réalisez que vous étiez naïf. À chaque marche, il prenait de plus en plus de retard, et chaque fois que vous donniez l\'ordre de lever le camp, il était le dernier à rassembler ses affaires et à commencer à marcher. Son équipement avait aussi commencé à être délabré. Bien qu\'il ait gardé ses pensées pour lui, en rétrospective, ses regards aigris et son désintérêt pour ses camarades montrent clairement qu\'il n\'était pas heureux de la direction prise par la compagnie ces derniers temps.\n\n Vous appelez vos hommes et découvrez de le mécontentement est à la hausse. Gardez les hommes bien nourris et abreuvés comme n\'importe quelle bête, et assurez-vous qu\'ils soient payés à temps, et avec un peu de chance %desertedbrother% sera le dernier à fuir dans la nuit. | Vous ne savez pas si c\'est à cause du bas salaire, de la menace de démembrement, des marches forcées sous une pluie glaciale, du langage grossier et de la nourriture grossière, des abus de la part de ses frères, des petits enfants qui jettent des pierres, du vent froid ou des nuits blanches, mais %desertedbrother% est devenu de plus en plus malheureux ces derniers temps jusqu\'à ce qu\'il ait apparemment renoncé à la vie de mercenaire.%SPEECH_ON%Je ne sais pas de quoi il se plaint. Tout me semble normal.%SPEECH_OFF%%otherbrother% dit en entendant tout ça. %desertedbrother% a choisi la grande route plutôt que %companyname%. Au moins, il a eu la décence de te dire en personne qu\'il a décidé de partir - même si, en y réfléchissant, c\'était peut-être pour toucher en personne le solde de son salaire. | Dernièrement, %desertedbrother% avait commencé à faire de longues promenades le soir quand le travail du jour était terminé. Bien que son habitude de s\'égarer seul n\'était pas vraiment sûre, il n\'y avait aucune raison de l\'arrêter quand on n\'avait pas besoin de lui au camp. Cependant, plus la compagnie était confrontée à des difficultés, plus ces promenades devenaient longues, jusqu\'à ce qu\'un matin, %desertedbrother% ne revienne pas du tout.\n\n%desertedbrother% a déserté %companyname%. C\'est probablement pour le mieux. | %desertedbrother% a été particulièrement lunatique ces derniers temps, passant toutes ses heures de repos à caresser un vieux couteau de lancer, une lame en si mauvais état qu\'elle ressemble plus à de la ferraille qu\'à une véritable arme. Il a passé la soirée de la veille à le lancer sur le tronc d\'un arbre mort, se levant à chaque fois avec un gémissement pour le récupérer et revenant plusieurs mètres en arrière pour s\'accroupir et le lancer à nouveau, jusque tard dans la nuit.\n\nIl est clair qu\'il était mécontent des récents revers que la compagnie a connus, et ce matin, il a trouvé le courage d\'entrer dans votre tente et d\'expliquer qu\'il allait quitter la compagnie pour chercher fortune ailleurs.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{Je peux difficilement le forcer à rester dans la compagnie... | Mauvaise nouvelle, en effet. | Un revers momentané. | Je ne peux pas laisser une telle chose se reproduire.}",
					function getResult( _event )
					{
						if (this.World.Assets.getEconomicDifficulty() != this.Const.Difficulty.Hard)
						{
							_event.m.Deserter.getItems().transferToStash(this.World.Assets.getStash());
						}

						_event.m.Deserter.getSkills().onDeath(this.Const.FatalityType.None);
						this.World.getPlayerRoster().remove(_event.m.Deserter);
						_event.m.Deserter = null;
						_event.m.Other = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Deserter.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Deserter.getName() + " quitte " + this.World.Assets.getName()
				});
				this.updateAchievement("Deserter", 1, 1);
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"desertedbrother",
			this.m.Deserter.getName()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Deserter = null;
	}

});

